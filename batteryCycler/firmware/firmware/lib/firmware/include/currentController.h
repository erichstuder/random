#ifndef CURRENT_CONTROLLER_H
#define CURRENT_CONTROLLER_H

void setCellCurrent(float value);
void currentControllerTick(void);
void setCurrentController_gainI(float);
float getControllerValue(void);

#endif