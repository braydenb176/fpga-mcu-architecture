#include "LIS3DH.h"

#include <stdio.h>

LIS3DH::LIS3DH(){
    //init float vals to 0
    x = 0;
    y = 0;
    z = 0;
}

//Initializes the accelerometer, returning true on success or false on failure.
bool LIS3DH::init(void){
    i2c_init(LIS3DH_i2c, BAUD);

    //printf("After i2c init\n");
    
    //set relevant pins to i2c function mode
    gpio_set_function(LIS3DH_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(LIS3DH_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(LIS3DH_SDA_PIN);
    gpio_pull_up(LIS3DH_SCL_PIN);   

    //printf("After gpio\n");
    
    set_reg(CTRL_REG_5, CTRL_REG_5_SETTINGS);
    //accelerometer settings, normal mode at 100 Hz
    set_reg(CTRL_REG_1, CTRL_REG_1_SETTINGS);
    set_reg(CTRL_REG_4, CTRL_REG_4_SETTINGS);
    //printf("After set\n");

    //check that init was successful
    //if ctrl_reg_1 is changed from default to provided vals, then it is successful
    if(read_reg(CTRL_REG_1) == CTRL_REG_1_SETTINGS){
        //printf("After set\n");
        return true;
    }
    else{
        return false;
    }
}

//Set a register on the LIS3DH to the given value.
void LIS3DH::set_reg(uint8_t reg, uint8_t val){
    uint8_t buf[2];
    buf[0] = reg;
    buf[1] = val;
    //printf("Reg: %u Val: %u \n", buf[0], buf[1]);
    i2c_write_blocking(LIS3DH_i2c, LIS3DH_ADDR, buf, 2, false);
}

//Reads and returns the byte at address reg on the accelerometer.
uint8_t LIS3DH::read_reg(uint8_t reg){
    uint8_t output;
    i2c_write_blocking(LIS3DH_i2c, LIS3DH_ADDR, &reg, 1, false);
    i2c_read_blocking(LIS3DH_i2c,LIS3DH_ADDR, &output, 1, false);
    return output;
}

//Updates the class members x, y, and z with the current acceleration values.
void LIS3DH::update(void){
    x = ((int16_t)((read_reg(OUT_X_H) << 8) | read_reg(OUT_X_L))) / CONVERT_RAW;
    y = ((int16_t)((read_reg(OUT_Y_H) << 8) | read_reg(OUT_Y_L))) / CONVERT_RAW;
    z = ((int16_t)((read_reg(OUT_Z_H) << 8) | read_reg(OUT_Z_L))) / CONVERT_RAW;
}

//Helpers, return gravitational data
float LIS3DH::getX(void){
    return x;
}
float LIS3DH::getY(void){
    return y;
}
float LIS3DH::getZ(void){
    return z;
}