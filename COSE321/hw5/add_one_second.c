#include <stdlib.h>

void add_one_second(char* time) {
    // 초, 분, 시간을 저장하는 변수
    int seconds, minutes, hours;

    // time의 주소에 저장된 값을 읽어옴
    seconds = (time[7]) * 10 + (time[8]);
    minutes = (time[4]) * 10 + (time[5]);
    hours = (time[1]) * 10 + (time[2]);

    // 시간을 1초씩 증가시킴
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

    // 변경된 값을 다시 time 주소에 저장
    time[1] = (hours / 10);
    time[2] = (hours % 10);
    time[4] = (minutes / 10);
    time[5] = (minutes % 10);
    time[7] = (seconds / 10);
    time[8] = (seconds % 10);
}
