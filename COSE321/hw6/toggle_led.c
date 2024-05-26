unsigned volatile char * gpio_led = (unsigned char *) 0x41200000;

int toggle_led(){
	int count;
    for (count=0; count < 0x400000; count++) ;
    *gpio_led = 0xFF;

    for (count=0; count < 0x400000; count++) ;
    *gpio_led = 0x00;

    return 0;
}
