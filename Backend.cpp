#include "Backend.h"
#include <qcolor.h>
#include <qvariant.h>
#include <random>
#include <QTimer>
#include <math.h>

Backend::Backend(QObject* parent) : QObject(parent)
{

	get_primary_numbers(primary_numbers);

	connect(&timer, &QTimer::timeout, this, [this]() {
		choose_sign();
		set_numbers();
		timer.stop();


		});
	
	
	
}

void Backend::setRoot(QObject* root)
{
	m_root = root;
	choose_sign();
	set_numbers();

	numpad = m_root->findChild<QObject*>("numpad");
	numpad->setProperty("visible", false);

	answer = m_root->findChild<QObject*>("check_answer");
	main_column = m_root->findChild<QObject*>("main_column");
	userinput = m_root->findChild<QObject*>("userinput");
}


void Backend::get_primary_numbers(vector<int>& vec)
{
	
	
	for (int i = 2; i < 103; i++) {
		bool is_prime = true;
		int limit = (int)sqrt(i);
		for (int j = 2; j <= limit; j++){
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
	example = m_root->findChild<QObject*>("example");


	if (text.isEmpty()) {
		return false;
	}
	timer.start(1);
	if (text == QString::number(result)) {
		answer->setProperty("text", QString("Correct!"));
		answer->setProperty("color", QColor("green"));
		userinput->setProperty("text", QString(""));
		return true;
	}
	else {
		answer->setProperty("text", QString("The answer was: ") + QString(QString::number(result)));
		answer->setProperty("color", QColor("red"));
		userinput->setProperty("text", QString(""));
		return false;
	}
	
	
}


void Backend::choose_sign()
{
	srand(time(NULL));
	switch (rand() % 4)
	{
	case 0:
		sign = '+';

		first_number = rand() % 200 + 1;
		second_number = rand() % 200 + 1;
		result = first_number + second_number;

		break;
	case 1:
		sign = '-';

		first_number = rand() % 200 + 1;
		second_number = rand() % first_number + 1;
		result = first_number - second_number;

		break;
	case 2:
		sign = '*';

		first_number = rand() % 15 + 1;
		second_number = rand() % 15 + 1;
		result = first_number * second_number;

		break;
	case 3:
		sign = '/';
		bool stop = true;
		first_number = rand() % 100 + 2;
		while (true) {
			stop = true;
			for (int el : primary_numbers) {
				if (el == first_number) {
					first_number = rand() % 100 + 1;
					stop = false;
					break;
				}
			}
			if (stop == true) {
				break;
			}
		}

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
		if (first_number != 0 and second_number != 0) {
			result = first_number / second_number;
		}
		break;
	};
}

void Backend::set_numbers()
{
	example = m_root->findChild<QObject*>("example");
	if (!example) return;

	QString s_first_number = QString::number(first_number);
	QString s_second_number = QString::number(second_number);
	QString s_sign = QString(sign);
	QString res = s_first_number + QString(" ") + s_sign + QString(" ") + s_second_number + QString(" = ");
	example->setProperty("text", res);
}


Q_INVOKABLE void Backend::enable_screen_numbers(bool checked)
{
	if (!numpad) return;
	

	if (checked == true) {
		numpad->setProperty("visible", true);
		main_column->setProperty("bottomPadding", 320);
		answer->setProperty("bottomPadding", 320);
	}
	else {
		numpad->setProperty("visible", false);
		main_column->setProperty("bottomPadding", 0);
		answer->setProperty("bottomPadding", 0);
	}

}

Q_INVOKABLE void Backend::enable_dark_theme(bool checked)
{
	QObject * check_box_text1 = m_root->findChild<QObject*>("check_box_text1");
	QObject* check_box_text2 = m_root->findChild<QObject*>("check_box_text2");
	QObject* userinput_background = m_root->findChild<QObject*>("userinput_background");
	QObject* numpad_buttons_background = m_root->findChild<QObject*>("numpad_buttons_background");


	if (checked == true) {
		m_root->setProperty("color", "black");
		example->setProperty("color", "white");
		check_box_text1->setProperty("color", "white");
		check_box_text2->setProperty("color", "white");
		userinput_background->setProperty("color", "black");
		userinput->setProperty("color", "white");
		if (numpad_buttons_background != nullptr) {
			numpad_buttons_background->setProperty("color", "black");
			numpad_buttons_background->setProperty("border.color", "white");
		}

	}
	else {
		m_root->setProperty("color", "white");
		example->setProperty("color", "black");
		check_box_text2->setProperty("color", "black");
		check_box_text1->setProperty("color", "black");
		userinput_background->setProperty("color", "white");
		userinput->setProperty("color", "black");

	}
	
}
