#include<linux/module.h>
#include<linux/kernel.h>
#include<linux/init.h>
#include<linux/moduleparam.h>



static char *msg = "default";
module_param(msg,charp,0660);

static int num =0;
module_param(num,int,0660);

static int init(void){

	int i;
	printk(KERN_INFO "Hello World CSCE-3402 :)\n");
	for(i=0;i<num;i++){
	printk(KERN_INFO "%s",msg);	
	}
	return 0;
}



static void cleanup(void){

	printk(KERN_INFO "Bye bye CSCE-3402 :) \n");



}


module_init(init);
module_exit(cleanup);




