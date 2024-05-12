#include <stdlib.h>

void add_one_second(char* time) {
    // ��, ��, �ð��� �����ϴ� ����
    int seconds, minutes, hours;

    // time�� �ּҿ� ����� ���� �о��
    seconds = (time[7]) * 10 + (time[8]);
    minutes = (time[4]) * 10 + (time[5]);
    hours = (time[1]) * 10 + (time[2]);

    // �ð��� 1�ʾ� ������Ŵ
    seconds++;
    if (seconds == 60) {
        seconds = 0;
        minutes++;
        if (minutes == 60) {
            minutes = 0;
            hours++;
            if (hours == 24) {
                hours = 0;
            }
        }
    }

    // ����� ���� �ٽ� time �ּҿ� ����
    time[1] = (hours / 10);
    time[2] = (hours % 10);
    time[4] = (minutes / 10);
    time[5] = (minutes % 10);
    time[7] = (seconds / 10);
    time[8] = (seconds % 10);
}
