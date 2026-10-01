#include <esp_log.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

#include "sdkconfig.h"

static const char * TAG = "MAIN";

extern "C" void app_main(void)
{
    ESP_LOGI(TAG, "--- Controlador por volante de inércia iniciando ---");
    ESP_LOGI(TAG,
             "Motor 0 em IO%d/IO%d/IO%d (enable IO%d)",
             CONFIG_M0_IN1_GPIO,
             CONFIG_M0_IN2_GPIO,
             CONFIG_M0_IN3_GPIO,
             CONFIG_M0_EN_GPIO);

    while (true)
    {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
