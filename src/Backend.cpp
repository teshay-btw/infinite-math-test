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
	get_primary_numbers(primary_numbers);

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

		
	}
	
	CloseHandle(file);

	connect(&timer_seconds_obj, &QTimer::timeout, this, [this]() {
		timer_seconds_temp--;
		emit timer_changed(timer_seconds_temp);

		if (timer_seconds_temp < 0) {
			timer_seconds_temp = timer_seconds;
			QMetaObject::invokeMethod(m_root, "send_answer");
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

	negative_numbers_checkbox = m_root->findChild<QObject*>("negative_cb");
	negative_numbers_checkbox->setProperty("checked", add_negatives);

	brackets_checkbox = m_root->findChild<QObject*>("brackets_cb");
	brackets_checkbox->setProperty("checked", add_brackets);

	theme_checkbox = m_root->findChild<QObject*>("dark_theme_cb");
	theme_checkbox->setProperty("checked", bool_theme);

	show_stats_checkbox = m_root->findChild<QObject*>("stats_cb");
	show_stats_checkbox->setProperty("checked", show_stats);

	numpad_checkbox = m_root->findChild<QObject*>("numpad_cb");
	numpad_checkbox->setProperty("checked", bool_numpad);

	timer_checkbox = m_root->findChild<QObject*>("timer_cb");
	timer_checkbox->setProperty("checked", is_timer_enabled);

	seconds_userinput = m_root->findChild<QObject*>("seconds_userinput");
	seconds_userinput->setProperty("text", QString::number(timer_seconds));
}

void Backend::get_primary_numbers(vector<int>& vec)
{


	for (int i = 2; i < 103; i++) {
		bool is_prime = true;
		int limit = (int)sqrt(i);
		for (int j = 2; j <= limit; j++) {
			if (i % j == 0) {
				is_prime = false;
				break;
			}
		}

		if (is_prime == true) {
			vec.push_back(i);
		}
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
		qDebug() << first_number << second_number;

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
}

Q_INVOKABLE void Backend::enable_negatives(bool is_enabled)
{
	add_negatives = is_enabled;
}

Q_INVOKABLE void Backend::enable_brackets(bool is_enabled)
{
	add_brackets = is_enabled;
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
	int num = rand() % 100 + 2;
	bool stop = false;
	while (stop == false) {
		stop = true;
		for (int el : primary_numbers) {
			if (el == num) {
				num = rand() % 100 + 2;
				stop = false;
				break;
			}
		}
	}

	
	return num;
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
	deleter = deleters[rand() % deleters.size()];
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

		first_number = rand() % 200 + 10;
		second_number = rand() % 200 + 10;
		
		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:    /////// ADDITIONAL PLUS
				additional_sign = '+';
				third_number = rand() % 200 + 10;
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
				third_number = 2 + rand() % (5 - 2);
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
					first_number = rand() % 50 + 1;
					second_number = rand() % 50 + 1;

					make_negative_if_enabled(first_number);
					make_negative_if_enabled(second_number);

					result = first_number + second_number;
				}
				else {
					second_number = rand() % 100 + 1;
					brackets_potisiton = 2;
				}

				int stop = false;
				while (stop == false) {
					stop = true;
					for (int el : primary_numbers) {
						if (brackets_potisiton == 1) {
							if (el == abs(result)) {

								first_number = rand() % 50 + 1;
								second_number = rand() % 50 + 1;
								make_negative_if_enabled(first_number);
								make_negative_if_enabled(second_number);

								result = first_number + second_number;
								stop = false;
								break;
							}
						}
						else if (brackets_potisiton == 2) {
							if (el == abs(second_number)) {
								second_number = rand() % 100 + 1;
								stop = false;
								break;
							}
						}
					}
				}

				vector<int> deleters;
				if (brackets_potisiton == 1) {
					for (int i = 2; i < 25; i++) {
						if (result % i == 0 and result != i) {
							deleters.push_back(i);
						}
					}
				}
				else if (brackets_potisiton == 2) {
					for (int i = 2; i < 25; i++) {
						if (second_number % i == 0 and second_number != i) {
							deleters.push_back(i);
						}
					}
					make_negative_if_enabled(second_number);
				}

				if (deleters.empty()) {
					return;
				}


				third_number = deleters[rand() % deleters.size()];
				make_negative_if_enabled(third_number);
				if (brackets_potisiton == 1) {
					result = (first_number + second_number) / third_number;
				}
				else if (brackets_potisiton == 2) {
					result = first_number + (second_number / third_number);
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

		first_number = rand() % 200 + 1;
		second_number = rand() % first_number + 1;
		

		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);


		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:       ///// ADDITIONAL PLUS
				additional_sign = '+';
				third_number = rand() % 200 + 5;
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

					first_number = (second_number - third_number) + rand() % (100 - second_number - third_number);
					make_negative_if_enabled(first_number);

					result = first_number - (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:     /////// ADDITIONAL MULTIPLICATION
				additional_sign = '*';
				
				if (rand() % 2 == 0) {
					third_number = 2 +  rand() % (5 - 2);
					make_negative_if_enabled(third_number);

					result = (first_number - second_number) * third_number;
					brackets_potisiton = 1;
				}
				else {
					third_number = rand() % 9 + 1;
					make_negative_if_enabled(third_number);
					
					second_number = rand() % 9 + 1;
					make_negative_if_enabled(second_number);

					first_number = (second_number * third_number) + rand() % (200 - second_number * third_number);
					make_negative_if_enabled(first_number);

					result = first_number - (second_number * third_number);
					brackets_potisiton = 2;
				}
				break;

			case 3:
				additional_sign = '/';

				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					result = first_number - second_number;
				}
				else {
					second_number = rand() % 100 + 1;
					brackets_potisiton = 2;
				}



				int stop = false;
				while (stop == false) {
					stop = true;
					for (int el : primary_numbers) {
						if (brackets_potisiton == 1) {
							if (el ==  abs(result) or result <= 5) {

								first_number = rand() % 100 + 1;
								second_number = rand() % 100 + 1;
								make_negative_if_enabled(second_number);
								make_negative_if_enabled(first_number);


								result = first_number - second_number;
								stop = false;
								break;
							}
						}
						else if (brackets_potisiton == 2) {
							if (el == abs(second_number)) {
								second_number = rand() % 100 + 1;

								stop = false;
								break;
							}
						}
					}
				}

				vector<int> deleters;
				if (brackets_potisiton == 1) {
					for (int i = 2; i < 25; i++) {
						if (result % i == 0 and result != i) {
							deleters.push_back(i);
						}
					}
				}
				else if (brackets_potisiton == 2) {
					for (int i = 2; i < 25; i++) {
						if (second_number % i == 0 and second_number != i) {
							deleters.push_back(i);
						}
					}
					make_negative_if_enabled(second_number);
				}

				if (deleters.empty()) {
					return;
				}


				third_number = deleters[rand() % deleters.size()];
				make_negative_if_enabled(third_number);
				if (brackets_potisiton == 1) {
					result = (first_number - second_number) / third_number;
				}
				else if (brackets_potisiton == 2) {
					result = first_number - (second_number / third_number);
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

		first_number = rand() % 13 + 2;
		second_number = rand() % 13 + 2;

		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:
				additional_sign = '+';
				third_number = rand() % 200 + 10;
				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number * second_number) + third_number;
					brackets_potisiton = 1;
				}
				else {
					second_number = rand() % 200 + 5;
					make_negative_if_enabled(second_number);

					third_number = rand() % 200 + 5;
					make_negative_if_enabled(third_number);

					first_number = 2 + rand() % (5 - 2);
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
					second_number = rand() % 200 + 1;
					third_number = rand() % second_number + 1;
					make_negative_if_enabled(third_number);
					first_number = rand() % 3 + 2;
					result = first_number * (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:
				additional_sign = '*';
				third_number = rand() % 13 + 2;
				make_negative_if_enabled(third_number);

				result = first_number * second_number * third_number;


				if (rand() % 2 == 0) 
					brackets_potisiton = 1;
				else 
					brackets_potisiton = 2;
				
				break;

			case 3:
				additional_sign = '/';

				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					result = first_number * second_number;
				}
				else {
					second_number = rand() % 100 + 1;
					brackets_potisiton = 2;
				}



				int stop = false;
				while (stop == false) {
					stop = true;
					for (int el : primary_numbers) {
						if (brackets_potisiton == 1) {
							if (el == result or result <= 5) {
								first_number = rand() % 8 + 2;
								second_number = rand() % 8 + 2;
								result = first_number * second_number;
								stop = false;
								break;
							}
						}
						else if (brackets_potisiton == 2) {
							if (el == second_number) {
								second_number = rand() % 100 + 1;
								stop = false;
								break;
							}
						}
					}
				}

				vector<int> deleters;
				if (brackets_potisiton == 1) {
					for (int i = 2; i < 25; i++) {
						if (result % i == 0 and result != i) {
							deleters.push_back(i);
						}
					}
				}
				else if (brackets_potisiton == 2) {
					for (int i = 2; i < 25; i++) {
						if (second_number % i == 0 and second_number != i) {
							deleters.push_back(i);
						}
					}
				}

				if (deleters.empty()) {
					return;
				}


				third_number = deleters[rand() % deleters.size()];
				make_negative_if_enabled(third_number);
				if (brackets_potisiton == 1) {
					result = (first_number * second_number) / third_number;
				}
				else if (brackets_potisiton == 2) {
					result = first_number * (second_number / third_number);
				}



				break;
			}
		}


		else {
			result = first_number * second_number;
		}


		break;
	case 3:
		sign = '/';
		first_number = generate_not_prime_number();

		vector<int> deleters;
		for (int i = 2; i < 25; i++) {
			if (first_number % i == 0 and first_number != i) {
				deleters.push_back(i);
			}
		}

		if (deleters.empty()) {
			return;
		}
		second_number = deleters[rand() % deleters.size()];

		make_negative_if_enabled(first_number);
		make_negative_if_enabled(second_number);

		if (add_brackets) {

			switch (rand() % 4)
			{
			case 0:
				additional_sign = '+';
				third_number = rand() % 200 + 1;
				make_negative_if_enabled(third_number);
				if (rand() % 2 == 0) {
					result = (first_number / second_number) + third_number;
					brackets_potisiton = 1;
				}
				else {
					second_number = rand() % 200 + 1;

					first_number = (second_number + third_number) * (rand() % 4 + 1);
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
					second_number = rand() % 200 + 1;
					make_negative_if_enabled(second_number);

					third_number = rand() % second_number + 1;
					make_negative_if_enabled(third_number);

					first_number = (second_number - third_number) * (rand() % 4 + 1);
					make_negative_if_enabled(first_number);

					result = first_number / (second_number - third_number);
					brackets_potisiton = 2;
				}
				break;
			case 2:
				additional_sign = '*';
				third_number = rand() % 9 + 1;
				make_negative_if_enabled(third_number);


				if (rand() % 2 == 0) {
					brackets_potisiton = 1;
					result = (first_number / second_number) * third_number;
				}
				else {
					second_number = rand() % 9 + 1;
					make_negative_if_enabled(second_number);

					first_number = (second_number * third_number) * (rand() % 4 + 1);
					make_negative_if_enabled(first_number);

					result = first_number / (second_number * third_number);
					brackets_potisiton = 2;
				}
				break;

			case 3:
				additional_sign = '/';

				result = first_number / second_number;

				if (rand() % 2 == 0) {
					brackets_potisiton = 1;

					int stop = false;
					while (stop == false) {
						stop = true;
						for (int el : primary_numbers) {
							if (abs(result) == el) {
								first_number = generate_not_prime_number();
								make_negative_if_enabled(first_number);
								second_number = generate_deleter(first_number);
								make_negative_if_enabled(second_number);

								result = first_number / second_number;
								stop = false;
								break;
							}
						}
					}
					third_number = generate_deleter(result);
					make_negative_if_enabled(third_number);

					result = (first_number / second_number) / third_number;
					
				}
				else {
					second_number = generate_not_prime_number();
					make_negative_if_enabled(second_number);

					third_number = generate_deleter(second_number);
					make_negative_if_enabled(third_number);

					first_number = (second_number / third_number) * (rand() % 4 + 1);
					make_negative_if_enabled(first_number);

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

void Backend::incorrect_answer()
{
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


