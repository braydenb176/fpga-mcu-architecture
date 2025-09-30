#include "pico/stdlib.h"
#include "hardware/i2c.h"

#define LIS3DH_i2c i2c1

//i2c values
#define LIS3DH_ADDR 0x18
#define BAUD (400 * 1000)

//for feather, different than regular pico
#define LIS3DH_SDA_PIN 2
#define LIS3DH_SCL_PIN 3

//LIS3DH Basic Operating Settings
#define CTRL_REG_1 0x20
#define CTRL_REG_1_SETTINGS 0x97
#define CTRL_REG_4 0x23
#define CTRL_REG_4_SETTINGS 0x80
#define CTRL_REG_5 0x24
#define CTRL_REG_5_SETTINGS 0x80

//LIS3DH output register addresses for accelerometer data
#define OUT_X_L 0x28
#define OUT_X_H 0x29
#define OUT_Y_L 0x2A
#define OUT_Y_H 0x2B
#define OUT_Z_L 0x2C
#define OUT_Z_H 0x2D

//the LSB is equal to 0.004 G, or 4 mG
#define CONVERT_RAW (64.0f / 0.004f)

class LIS3DH{
    private:
        //Class members representing the three acceleration values in units of g (Earth’s gravitational acceleration).
        float x,y,z;
        
    public:
        LIS3DH(void);

        //Initializes the accelerometer, returning true on success or false on failure.
        bool init(void);

        //Set a register on the LIS3DH to the given value.
        void set_reg(uint8_t reg, uint8_t val);

        //Reads and returns the byte at address reg on the accelerometer.
        uint8_t read_reg(uint8_t reg);

        //Updates the class members x, y, and z with the current acceleration values.
        void update(void);

        //Helpers, return gravitational data
        float getX(void);
        float getY(void);
        float getZ(void);
};