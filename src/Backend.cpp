#include "Backend.h"
#include <qcolor.h>
#include <qvariant.h>
#include <random>
#include <QTimer>
#include <math.h>
#include <thread>
#include <sstream>


Backend::Backend(QObject* parent) : QObject(parent)
{
	srand(time(NULL));
	get_non_primary_numbers(1);

	HANDLE file = CreateFileW(
		L"settings.txt",
		GENERIC_READ,
		FILE_SHARE_READ,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
	);
	if (file != INVALID_HANDLE_VALUE) {
		DWORD fileSize = GetFileSize(file, NULL);
		if (fileSize == INVALID_FILE_SIZE) {
			qDebug() << "Settings file size error";
			CloseHandle(file);
		}
		string buff;
		buff.resize(fileSize);
		

		DWORD bytesRead;
		if (!ReadFile(file, buff.data(), fileSize, &bytesRead, NULL)) {
			qDebug() << "Settings file error";
		}
		if (bytesRead != fileSize) {
			qDebug() << "Settings file bytes error";
		}


		std::stringstream ss(buff);
		QList<int> temp;

		double value;
		while (ss >> value) {
			temp.push_back(static_cast<int>(value));
		}


		streak = temp[0];
		correct = temp[1];
		incorrect = temp[2];
		overall = temp[3];
		is_timer_enabled = temp[4];
		add_negatives = temp[5];
		add_brackets = temp[6];
		show_stats = temp[7];
		bool_theme = temp[8];
		bool_numpad = temp[9];
		is_timer_enabled = temp[10];
		timer_seconds = temp[11];
		incorrect_percent = temp[12];
		level = temp[13];

		
	}
	
	CloseHandle(file);

	connect(&timer_seconds_obj, &QTimer::timeout, this, [this]() {
		timer_seconds_temp--;
		emit timer_changed(timer_seconds_temp);

		if (timer_seconds_temp < 0) {
			timer_seconds_temp = timer_seconds;
			QMetaObject::invokeMethod(m_root, "send_answer");
			//QMetaObject::invokeMethod(progress_bar_animation, "stop");
		}
		if (!is_timer_enabled) {
			timer_seconds_obj.stop();
			timer_seconds_temp = timer_seconds;
		}
		});

}

void Backend::start_loop() {
	emit timer_changed(timer_seconds_temp);

	timer_seconds_obj.start(1000);

	progress_bar_animation->setProperty("duration", timer_seconds*1000);

	QMetaObject::invokeMethod(progress_bar_animation, "stop");
	progress_bar_animation->setProperty("from", 100);
	progress_bar_animation->setProperty("to", 0);
	QMetaObject::invokeMethod(progress_bar_animation, "start");

}

void Backend::setRoot(QObject* root)
{
	m_root = root;
	choose_sign();
	set_numbers();

	numpad = m_root->findChild<QObject*>("numpad");
	numpad->setProperty("visible", false);

	userinput = m_root->findChild<QObject*>("userinput");

	streak_text = m_root->findChild<QObject*>("streak");
	streak_text->setProperty("text", streak);
	incorrect_percent_text = m_root->findChild<QObject*>("incorrect_percent");
	incorrect_percent_text->setProperty("text", QString::number(incorrect_percent) + QString("%"));
	correct_text = m_root->findChild<QObject*>("correct_number_text");
	correct_text->setProperty("text", correct);
	incorrect_text = m_root->findChild<QObject*>("incorrect_number_text");
	incorrect_text->setProperty("text", incorrect);

	incorrect_answer_rectangle = m_root->findChild<QObject*>("incorrect_answer_rectangle");

	negative_numbers_checkbox = m_root->findChild<QObject*>("negative_cb");
	negative_numbers_checkbox->setProperty("checked", add_negatives);

	brackets_checkbox = m_root->findChild<QObject*>("brackets_cb");
	brackets_checkbox->setProperty("checked", add_brackets);

	show_stats_checkbox = m_root->findChild<QObject*>("stats_cb");
	show_stats_checkbox->setProperty("checked", show_stats);

	numpad_checkbox = m_root->findChild<QObject*>("numpad_cb");
	numpad_checkbox->setProperty("checked", bool_numpad);

	timer_checkbox = m_root->findChild<QObject*>("timer_cb");
	timer_checkbox->setProperty("checked", is_timer_enabled);

	seconds_userinput = m_root->findChild<QObject*>("seconds_userinput");
	seconds_userinput->setProperty("text", QString::number(timer_seconds));

	progress_bar_animation = m_root->findChild<QObject*>("progress_bar_animation");


	level1_checkbox = m_root->findChild<QObject*>("level1_cb");
	level2_checkbox = m_root->findChild<QObject*>("level2_cb");
	level3_checkbox = m_root->findChild<QObject*>("level3_cb");

	switch (level)
	{
	case 1:
		level1_checkbox->setProperty("checked", true);
		break;
	case 2:
		level2_checkbox->setProperty("checked", true);
		break;
	case 3:
		level3_checkbox->setProperty("checked", true);
		break;
	}
}

void Backend::get_non_primary_numbers(int level)
{
	non_primary_numbers.clear();
	int start = 0;
	int end = 0;

	if (level == 1) { start = 2; end = 100; }
	else if (level == 2) { start = 100; end = 200; }
	else if (level == 3) { start = 200; end = 300; }

	for (int n = start; n <= end; ++n) {
		bool prime = true;

		if (n < 2) prime = false;
		else {
			for (int i = 2; i * i <= n; ++i) {
				if (n % i == 0) {
					prime = false;
					break;
				}
			}
		}

		if (!prime) non_primary_numbers.push_back(n);
	}



}

Q_INVOKABLE bool Backend::check_answer(QString text)
{
	if (timer_seconds_temp > 0) {
		timer_seconds_temp = timer_seconds;
	}

	if (is_timer_enabled)
		start_loop();

	if (text.isEmpty()) {
		if (!is_timer_enabled)
			return false;
	}

	if (text == QString::number(result)) {
		correct_answer();
		choose_sign();

		set_numbers();
		return true;
	}
	else {
		incorrect_answer();
		choose_sign();

		set_numbers();
		return false;
	}

	choose_sign();

	set_numbers();
	


}

Q_INVOKABLE void Backend::enable_timer(bool is_enabled)
{
	is_timer_enabled = is_enabled;
	if (is_timer_enabled and progress_bar_animation != nullptr) {
		progress_bar_animation->setProperty("duration", timer_seconds * 1000);
		QMetaObject::invokeMethod(progress_bar_animation, "stop");
		progress_bar_animation->setProperty("from", 100);
		progress_bar_animation->setProperty("to", 0);
	}
}

Q_INVOKABLE void Backend::enable_negatives(bool is_enabled)
{
	add_negatives = is_enabled;
	if (is_timer_enabled and progress_bar_animation != nullptr and timer_seconds_obj.isActive() == true) {
		progress_bar_animation->setProperty("duration", timer_seconds * 1000);
		QMetaObject::invokeMethod(progress_bar_animation, "stop");
		progress_bar_animation->setProperty("from", 100);
		progress_bar_animation->setProperty("to", 0);
		QMetaObject::invokeMethod(progress_bar_animation, "start");
	}
}

Q_INVOKABLE void Backend::enable_brackets(bool is_enabled)
{
	add_brackets = is_enabled;
	if (is_timer_enabled and progress_bar_animation != nullptr and timer_seconds_obj.isActive() == true) {
		progress_bar_animation->setProperty("duration", timer_seconds * 1000);
		QMetaObject::invokeMethod(progress_bar_animation, "stop");
		progress_bar_animation->setProperty("from", 100);
		progress_bar_animation->setProperty("to", 0);
		QMetaObject::invokeMethod(progress_bar_animation, "start");
	}
}

Q_INVOKABLE void Backend::set_timer_seconds(QString seconds)
{
	timer_seconds = seconds.toInt();
	emit timer_changed(timer_seconds);
}

Q_INVOKABLE void Backend::set_theme(bool theme)
{
	bool_theme = theme;
}

Q_INVOKABLE void Backend::set_show_stats(bool show_stats)
{
	this->show_stats = show_stats;
}

Q_INVOKABLE void Backend::set_numpad(bool enable_numpad)
{
	bool_numpad = enable_numpad;
}

int Backend::generate_not_prime_number()
{

	return non_primary_numbers[rand() % non_primary_numbers.size()];
}

int Backend::generate_deleter(int number)
{
	int deleter;
	vector<int> deleters;

	for (int i = 2; i < 25; i++) {
		if (number % i == 0 and number != i) {
			deleters.push_back(i);
		}
	}
	if (!deleters.empty())
		deleter = deleters[rand() % deleters.size()];
	else deleter = number;
	return deleter;
}

void Backend::make_negative_if_enabled(int &number)
{
	if (add_negatives) {
		if (rand() % 2 == 1) number *= -1;
	}
}

void Backend::choose_sign()
{
	
	switch (rand() % 4)
	{
	case 0:   /////////// PLUS
		sign = '+';


		if (level == 1)
		{
			first_number = rand() % 200 + 10;
			second_number = rand() % 200 + 10;
		}
		else if (level == 2) {
			first_number = rand() % 500 + 200;
			second_number = rand() % 500 + 200;
		}
		else if (level == 3) {
			first_number = rand() % 800 + 700;
			second_number = rand() % 800 + 700;
		}
		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:    /////// ADDITIONAL PLUS
				additional_sign = '+';
				if (level == 1)
				{
					third_number = rand() % 200 + 10;
				}
				else if (level == 2) {
					third_number = rand() % 500 + 200;
				}
				else if (level == 3) {
					third_number = rand() % 800 + 700;
				}
				
				make_negative_if_enabled(third_number);
				result = first_number + second_number + third_number;

				if (rand() % 2 == 0) brackets_potisiton = 1;
				else brackets_potisiton = 2;

				break;
			case 1:		/////// ADDITIONAL MINUS
				additional_sign = '-'; 
				
				if (rand() % 2 == 0) {
					
					result = first_number + second_number;
					third_number = rand() % result + 1;
					make_negative_if_enabled(third_number);
					result = (first_number + second_number) - third_number;
					brackets_potisiton = 1;
				}
				else {

					third_number = rand() % second_number + 1;
					make_negative_if_enabled(third_number);
					result = first_number + (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:  /////// ADDITIONAL MULTIPLICATION
				additional_sign = '*';
				if (level == 1)
				{
					third_number = rand() % 3 + 2;
				}
				else if (level == 2) {
					third_number = rand() % 10 + 5;
				}
				else if (level == 3) {
					third_number = rand() % 10 + 10;
				}

				
				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number + second_number) * third_number;
					brackets_potisiton = 1;
				}
				else {
					result = first_number + (second_number * third_number);
					brackets_potisiton = 2;
				}
				break; 

			case 3:  /////// ADDITIONAL DIVISION
				additional_sign = '/';
				
				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					qDebug() << "+ / ";
					bool stop = false;
					while (true) {
						for (int i = 2; i < 10; i++) {
							if ((first_number + second_number) % i == 0) {
								stop = true;
								break;
							}
							
						}
						if (!stop) {
							if (level == 1)
							{
								first_number = rand() % 200 + 10;
								second_number = rand() % 200 + 10;
							}
							else if (level == 2) {
								first_number = rand() % 500 + 200;
								second_number = rand() % 500 + 200;
							}
							else if (level == 3) {
								first_number = rand() % 800 + 700;
								second_number = rand() % 800 + 700;
							}
						}
						if (stop == true) break;
					}

					third_number = generate_deleter(first_number + second_number);
					make_negative_if_enabled(third_number);
					result = (first_number + second_number) / third_number;
				}
				else {
					get_non_primary_numbers(level);
					second_number = generate_not_prime_number();

					third_number = generate_deleter(second_number);
					make_negative_if_enabled(third_number);
					result = first_number + (second_number / third_number);
					brackets_potisiton = 2;
				}


				break;
			}
		}
		else {
			result = first_number + second_number;
		}
		

		break;
	case 1:    /////////////////////  MINUS
		sign = '-';
		if (level == 1) {
			first_number = rand() % 200 + 1;
			second_number = rand() % first_number + 1;
		}
		else if (level == 2) {
			first_number = rand() % 500 + 200;
			second_number = rand() % (first_number-200) + 200;
		}
		else if (level == 3) {
			first_number = rand() % 800 + 700;
			second_number = rand() % (first_number - 700) + 700;
		}
		
		

		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);


		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:       ///// ADDITIONAL PLUS
				additional_sign = '+';
				if (level == 1)
				{
					third_number = rand() % 200 + 10;
				}
				else if (level == 2) {
					third_number = rand() % 500 + 200;
				}
				else if (level == 3) {
					third_number = rand() % 800 + 700;
				}
				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number - second_number) + third_number;
					brackets_potisiton = 1;
				}
				else {
					first_number = (second_number + third_number) + rand() % (500 - second_number + third_number);
					result = first_number - (second_number + third_number);
					brackets_potisiton = 2;
				}
				break;
			case 1:     ////// ADDITIONAL MINUS
				additional_sign = '-';

				if (rand() % 2 == 0) {

					result = first_number - second_number;
					third_number = rand() % result + 1;
					make_negative_if_enabled(third_number);
					result = (first_number - second_number) - third_number;
					brackets_potisiton = 1;
				}
				else {

					third_number = rand() % second_number + 1;
					make_negative_if_enabled(third_number);

					first_number = (second_number - third_number) + rand() % ((level == 1 ? 100 : level == 2 ? 500 : level == 3 ? 1000 : 100) - second_number - third_number);
					make_negative_if_enabled(first_number);

					result = first_number - (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:     /////// ADDITIONAL MULTIPLICATION
				additional_sign = '*';
				
				if (rand() % 2 == 0) {
					if (level == 1)
					{
						third_number = rand() % 3 + 2;
					}
					else if (level == 2) {
						third_number = rand() % 10 + 5;
					}
					else if (level == 3) {
						third_number = rand() % 10 + 10;
					}
					make_negative_if_enabled(third_number);

					result = (first_number - second_number) * third_number;
					brackets_potisiton = 1;
				}
				else {
					if (level == 1) {
						third_number = rand() % 13 + 2;
						
					}
					else if (level == 2) {
						third_number = rand() % 35 + 15;

					}
					else if (level == 3) {
						third_number = rand() % 50 + 50;

					}
					make_negative_if_enabled(third_number);
					
					if (level == 1) {
						second_number = rand() % 13 + 2;

					}
					else if (level == 2) {
						second_number = rand() % 35 + 15;

					}
					else if (level == 3) {
						second_number = rand() % 50 + 50;

					}
					make_negative_if_enabled(second_number);

					first_number = (second_number * third_number) + rand() % ((level == 1 ? 100 : level == 2 ? 500 : level == 3 ? 1000 : 100) - second_number * third_number);
					make_negative_if_enabled(first_number);

					result = first_number - (second_number * third_number);
					brackets_potisiton = 2;
				}
				break;
				
			case 3:
				
				additional_sign = '/';
				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					qDebug() << "- / ";

					bool stop = false;
					while (true) {
						for (int i = 2; i < 10; i++) {
							if ((first_number - second_number) % i == 0) {
								stop = true;
								break;
							}

						}
						if (!stop) {
							if (level == 1) {
								first_number = rand() % 200 + 1;
								second_number = rand() % first_number + 1;
							}
							else if (level == 2) {
								first_number = rand() % 500 + 200;
								second_number = rand() % (first_number - 200) + 200;
							}
							else if (level == 3) {
								first_number = rand() % 800 + 700;
								second_number = rand() % (first_number - 700) + 700;
							}
						}
						if (stop == true) break;
					}


					third_number = generate_deleter(first_number - second_number);
					make_negative_if_enabled(third_number);
					result = (first_number - second_number) / third_number;
				}
				else {

					get_non_primary_numbers(level);
					second_number = generate_not_prime_number();
					make_negative_if_enabled(third_number);

					third_number = generate_deleter(second_number);
					make_negative_if_enabled(third_number);

					first_number = rand() % ((level == 1 ? 100 : level == 2 ? 500 : level == 3 ? 1000 : 100));
					make_negative_if_enabled(first_number);
					result = first_number - (second_number / third_number);
					brackets_potisiton = 2;
				}

				break;
				
			}
		}
		else {
			result = first_number - second_number;
		}
		break;
	case 2:
		sign = '*';
		if (level == 1) {
			first_number = rand() % 13 + 2;
			second_number = rand() % 13 + 2;
		}
		else if (level == 2) {
			first_number = rand() % 35 + 15;
			second_number = rand() % 35 + 15;
		}
		else if (level == 3) {
			first_number = rand() % 50 + 50;
			second_number = rand() % 50 + 50;
		}
		

		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:
				additional_sign = '+';

				if (level == 1)
				{
					third_number = rand() % 200 + 10;
				}
				else if (level == 2) {
					third_number = rand() % 500 + 200;
				}
				else if (level == 3) {
					third_number = rand() % 800 + 700;
				}


				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number * second_number) + third_number;
					brackets_potisiton = 1;
				}
				else {
					if (level == 1)
					{
						second_number = rand() % 200 + 10;
					}
					else if (level == 2) {
						second_number = rand() % 500 + 200;
					}
					else if (level == 3) {
						second_number = rand() % 800 + 700;
					}
					make_negative_if_enabled(second_number);


					if (level == 1) {
						first_number = rand() % 3 + 2;
					}
					else if (level == 2) {
						first_number = rand() % 10 + 15;
					}
					else if (level == 3) {
						first_number = rand() % 20 + 20;
					}
					make_negative_if_enabled(first_number);

					result = first_number * (second_number + third_number);
					brackets_potisiton = 2;
				}
				break;
			case 1:
				additional_sign = '-';

				if (rand() % 2 == 0) {

					result = first_number * second_number;

					third_number = rand() % result + 1;
					make_negative_if_enabled(third_number);

					result = (first_number * second_number) - third_number;
					brackets_potisiton = 1;
				}
				else {
					if (level == 1)
					{
						second_number = rand() % 200 + 10;
					}
					else if (level == 2) {
						second_number = rand() % 500 + 200;
					}
					else if (level == 3) {
						second_number = rand() % 800 + 700;
					}

					third_number = rand() % second_number + 1;
					make_negative_if_enabled(third_number);

					first_number = rand() % 3 + 2;
					if (level == 1)
					{
						first_number = rand() % 3 + 2;
					}
					else if (level == 2) {
						first_number = rand() % 10 + 5;
					}
					else if (level == 3) {
						first_number = rand() % 10 + 10;
					}

					result = first_number * (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:
				additional_sign = '*';
				if (level == 1) {
					third_number = rand() % 3 + 2;

				}
				else if (level == 2) {
					third_number = rand() % 10 + 5;

				}
				else if (level == 3) {
					third_number = rand() % 15 + 15;

				}
				make_negative_if_enabled(third_number);

				result = first_number * second_number * third_number;


				if (rand() % 2 == 0) 
					brackets_potisiton = 1;
				else 
					brackets_potisiton = 2;
				
				break;
				
			case 3:
				additional_sign = '/';
				qDebug() << "* / ";
				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					third_number = generate_deleter(first_number * second_number);
					make_negative_if_enabled(third_number);
					result = (first_number * second_number) / third_number;
				}
				else {
					get_non_primary_numbers(level);
					second_number = generate_not_prime_number();

					third_number = generate_deleter(second_number);
					make_negative_if_enabled(third_number);
					make_negative_if_enabled(second_number);

					result = first_number * (second_number / third_number);
					brackets_potisiton = 2;
				}


				break;
			}
		}


		else {
			result = first_number * second_number;
		}


		break;
	case 3: ////////////// DIVISION
		sign = '/';
		if (level == 1) {
			get_non_primary_numbers(1);
			first_number = generate_not_prime_number();
		}
		else if (level == 2) {
			get_non_primary_numbers(2);
			first_number = generate_not_prime_number();
		}
		else if (level == 3) {
			get_non_primary_numbers(3);
			first_number = generate_not_prime_number();
		}

		second_number = generate_deleter(first_number);
		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:
				additional_sign = '+';


				if (level == 1)
				{
					third_number = rand() % 200 + 10;
				}
				else if (level == 2) {
					third_number = rand() % 500 + 200;
				}
				else if (level == 3) {
					third_number = rand() % 800 + 700;
				}



				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number / second_number) + third_number;
					brackets_potisiton = 1;
				}
				else {
					if (level == 1)
					{
						second_number = rand() % 200 + 10;
					}
					else if (level == 2) {
						second_number = rand() % 500 + 200;
					}
					else if (level == 3) {
						second_number = rand() % 800 + 700;
					}


					if (level == 1)
					{
						first_number = (second_number + third_number) * (rand() % 4 + 1);
					}
					else if (level == 2) {
						first_number = (second_number + third_number) * (rand() % 10 + 15);
					}
					else if (level == 3) {
						first_number = (second_number + third_number) * (rand() % 35 + 15);
					}
					
					make_negative_if_enabled(first_number);


					result = first_number / (second_number + third_number);
					brackets_potisiton = 2;
				}
				break;
			case 1:
				additional_sign = '-';

				if (rand() % 2 == 0) {

					result = first_number / second_number;
					third_number = rand() % result + 1;
					make_negative_if_enabled(third_number);

					result = (first_number / second_number) - third_number;
					brackets_potisiton = 1;
				}
				else {
					if (level == 1)
					{
						second_number = rand() % 200 + 10;
					}
					else if (level == 2) {
						second_number = rand() % 500 + 200;
					}
					else if (level == 3) {
						second_number = rand() % 800 + 700;
					}
					make_negative_if_enabled(second_number);

					third_number = rand() % (second_number - 1) + 1;
					make_negative_if_enabled(third_number);

					first_number = (second_number - third_number) * (level == 1 ? (rand() % 4 + 2) : level==2 ? (rand() % 10 + 10) : level == 3 ? (rand() % 10 + 20) : (rand() % 4 + 2));
					make_negative_if_enabled(first_number);

					result = first_number / (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:
				additional_sign = '*';
				if (level == 1) {
					third_number = rand() % 13 + 2;

				}
				else if (level == 2) {
					third_number = rand() % 35 + 15;

				}
				else if (level == 3) {
					third_number = rand() % 50 + 50;

				}
				make_negative_if_enabled(third_number);


				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					result = (first_number / second_number) * third_number;
				}
				else {
					if (level == 1) {
						second_number = rand() % 13 + 2;

					}
					else if (level == 2) {
						second_number = rand() % 35 + 15;

					}
					else if (level == 3) {
						second_number = rand() % 50 + 50;

					}
					make_negative_if_enabled(second_number);

					first_number = (second_number * third_number) * (level == 1 ? (rand() % 4 + 2) : level == 2 ? (rand() % 10 + 5) : level == 3 ? (rand() % 15 + 15) : (rand() % 4 + 2));
					make_negative_if_enabled(first_number);

					result = first_number / (second_number * third_number);
					brackets_potisiton = 2;
				}
				break;
				
			case 3:
				additional_sign = '/';
				qDebug() << "/ / ";
				if (rand() % 2 == 0) {
					brackets_potisiton = 1;

					bool stop = false;
					while (true) {
						stop = false;
						for (int i = 2; i < 10; i++) {
							if ((first_number / second_number) % i == 0) {
								stop = true;
								break;
							}

						}
						if (!stop) {
							get_non_primary_numbers(level);
							first_number = generate_not_prime_number();
							second_number = generate_deleter(first_number);
							
						}
						if (stop == true) break;
					}



					third_number = generate_deleter(first_number / second_number);
					make_negative_if_enabled(third_number);
					result = (first_number / second_number) / third_number;
				}
				else {
					get_non_primary_numbers(level);
					second_number = generate_not_prime_number();
					third_number = generate_deleter(second_number);
					make_negative_if_enabled(third_number);
					make_negative_if_enabled(second_number);
					first_number = (second_number / third_number) * (level == 1 ? (rand() % 3 + 2) : level == 2 ? (rand() % 10 + 5) : level == 3 ? (rand() % 15 + 15) : (rand() % 3 + 2));
					result = first_number / (second_number / third_number);
					brackets_potisiton = 2;
				}

				break;
			}
		}


		else {
			if (first_number != 0 and second_number != 0)
				result = first_number / second_number;
		}
		break;
	};

	
}

void Backend::set_numbers()
{
	example = m_root->findChild<QObject*>("example");
	if (!example) return;


	QString s_second_number = QString::number(second_number);
	QString s_first_number = QString::number(first_number);
	QString s_third_number = QString::number(third_number);
	if (first_number < 0) {
		s_first_number = QString("(") + QString::number(first_number) + QString(")");
	}
	if (second_number < 0) {
		s_second_number = QString("(") + QString::number(second_number) + QString(")");
	}
	if (third_number < 0) {
		s_third_number = QString("(") + QString::number(third_number) + QString(")");
	}

	QString s_sign = QString(sign);
	QString res;


	if (add_brackets) {

		if (brackets_potisiton == 1) {
			res = QString("(") + s_first_number + QString(" ") + s_sign + QString(" ") + s_second_number + QString(")") + QString(" ") + QString(additional_sign) + QString(" ") + s_third_number + QString(" = ");
		}
		else {
			res = s_first_number + QString(" ") + s_sign + QString(" ") + QString("(")  + s_second_number + QString(" ") + QString(additional_sign) + QString(" ") + s_third_number + QString(")") + QString(" = ");
		}
	}
	else {
		 res = s_first_number + QString(" ") + s_sign + QString(" ") + s_second_number + QString(" = ");
	}

	example->setProperty("text", res);
}

Q_INVOKABLE void Backend::set_level(int number)
{
	level = number;
	if (is_timer_enabled and progress_bar_animation != nullptr and timer_seconds_obj.isActive() == true) {
		progress_bar_animation->setProperty("duration", timer_seconds * 1000);
		QMetaObject::invokeMethod(progress_bar_animation, "stop");
		progress_bar_animation->setProperty("from", 100);
		progress_bar_animation->setProperty("to", 0);
		QMetaObject::invokeMethod(progress_bar_animation, "start");
	}
}

void Backend::incorrect_answer()
{
	incorrect_answer_rectangle->setProperty("visible", true);
	userinput->setProperty("text", QString(""));

	streak = 0;
	streak_text->setProperty("text", QString::number(streak));

	incorrect++;
	incorrect_text->setProperty("text", QString::number(incorrect));

	overall++;
	incorrect_percent = round(static_cast<float>(((static_cast<double>(incorrect) / overall) * 100)));
	incorrect_percent_text->setProperty("text", QString::number(incorrect_percent) + "%");

	QMetaObject::invokeMethod(m_root, "set_the_answer", Q_ARG(QVariant, QString::number(result)));
	QMetaObject::invokeMethod(m_root, "set_red_color");


}

void Backend::correct_answer()
{
	incorrect_answer_rectangle->setProperty("visible", false);
	userinput->setProperty("text", QString(""));

	streak++;
	streak_text->setProperty("text", QString::number(streak));

	correct++;
	correct_text->setProperty("text", QString::number(correct));

	overall++;
	incorrect_percent = round(static_cast<float>(((static_cast<double>(incorrect) / overall) * 100)));
	incorrect_percent_text->setProperty("text", QString::number(incorrect_percent) + "%");

	QMetaObject::invokeMethod(m_root, "set_the_answer", Q_ARG(QVariant, QString(" ")));
	QMetaObject::invokeMethod(m_root, "set_green_color");


}


