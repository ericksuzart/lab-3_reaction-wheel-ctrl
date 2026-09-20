#include <esp_log.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

static const char * TAG = "MAIN";

extern "C" void app_main(void)
{
    ESP_LOGI(TAG, "--- Controlador por volante de inércia iniciando ---");

    while (true)
    {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
