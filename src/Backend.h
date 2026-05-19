#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <Windows.h>
#include <QTimer>

using namespace std;


class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject* parent = nullptr);
    void start_loop();
    void setRoot(QObject* root);
    
    void get_primary_numbers(vector<int>& vec);
    Q_INVOKABLE bool check_answer(QString text);
    Q_INVOKABLE void enable_timer(bool is_enabled);
    Q_INVOKABLE void enable_negatives(bool is_enabled);
    Q_INVOKABLE void enable_brackets(bool is_enabled);
    Q_INVOKABLE void set_timer_seconds(QString seconds);
    int generate_not_prime_number();
    int generate_deleter(int number);
    void make_negative_if_enabled(int& number);
    void choose_sign();
    void set_numbers();
    void incorrect_answer();
    void correct_answer();


signals:
    void timer_changed(int value);


private:
    QObject* m_root = nullptr;
    QObject* example = nullptr;
    QObject* userinput = nullptr;


    QTimer timer_seconds_obj;

    QObject* numpad;
    char sign = '+';
    int first_number = 0;
    int second_number = 0;
    int third_number = 0;
    int result = 0;
    bool is_primary = true;
    vector<int> primary_numbers;


    int streak = 0;
    QObject* streak_text = nullptr;

    int incorrect_percent = 0;
    QObject* incorrect_percent_text = nullptr;

    int correct = 0;
    QObject* correct_text = nullptr;

    float incorrect = 0;
    QObject* incorrect_text = nullptr;

    int overall = 0;
    
    
    int timer_seconds = 10;
    int timer_seconds_temp = timer_seconds;
    bool is_timer_enabled = 0;

    
    bool add_negatives = 0;
    bool add_brackets = 0;
    char additional_sign;
    int brackets_potisiton = 0;

};

