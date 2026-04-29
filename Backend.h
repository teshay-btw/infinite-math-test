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
     
    // Q_INVOKABLE говорит что метод можно вызвать в qml
    void setRoot(QObject* root);
    void get_primary_numbers(vector<int>& vec);
    Q_INVOKABLE bool check_answer(QString text);
    void choose_sign();
    void set_numbers();
    Q_INVOKABLE void enable_screen_numbers(bool checked);
    Q_INVOKABLE void enable_dark_theme(bool checked);



private:
    QObject* m_root = nullptr;
    QObject* example = nullptr;
    QObject* answer = nullptr;
    QObject* main_column = nullptr;
    QObject* userinput = nullptr;
    QTimer timer;
    QObject* numpad;
    char sign = '+';
    int first_number = 0;
    int second_number = 0;
    int result = 0;
    bool is_primary = true;
    vector<int> primary_numbers;

};

