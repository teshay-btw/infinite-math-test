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
    Q_INVOKABLE void set_theme(bool theme);
    Q_INVOKABLE void set_show_stats(bool show_stats);
    Q_INVOKABLE void set_numpad(bool enable_numpad);
    int generate_not_prime_number();
    int generate_deleter(int number);
    void make_negative_if_enabled(int& number);
    Q_INVOKABLE void choose_sign();
    Q_INVOKABLE void set_numbers();
    void incorrect_answer();
    void correct_answer();






    int streak = 0;
    QObject* streak_text = nullptr;

    float incorrect_percent = 0;
    QObject* incorrect_percent_text = nullptr;

    int correct = 0;
    QObject* correct_text = nullptr;

    int incorrect = 0;
    QObject* incorrect_text = nullptr;

    int overall = 0;


    int timer_seconds = 10;
    int timer_seconds_temp = timer_seconds;
    bool is_timer_enabled = 0;


    bool add_negatives = 0;
    bool add_brackets = 0;

    bool show_stats = 0;
    bool bool_theme = 0;
    bool bool_numpad = 0;
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


   
    char additional_sign;
    int brackets_potisiton = 0;



    QObject* negative_numbers_checkbox;
    QObject* brackets_checkbox;
    QObject* theme_checkbox;
    QObject* show_stats_checkbox;
    QObject* numpad_checkbox;
    QObject* timer_checkbox;
    QObject* seconds_userinput;
};

