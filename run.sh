#!/bin/sh

if [ -f ${MQTT_USERNAME_FILE:-'/run/secrets/mqtt_username'} ]; then
  echo "MQTT_USERNAME_FILE Found. Setting MQTT_USERNAME from MQTT_USERNAME_FILE contents"
  MQTT_USERNAME=$(cat ${MQTT_USERNAME_FILE:-'/run/secrets/mqtt_username'})
fi
if [ -f ${MQTT_PASSWORD_FILE:-'/run/secrets/mqtt_password'} ]; then
  echo "MQTT_PASSWORD_FILE Found. Setting MQTT_PASSWORD from MQTT_PASSWORD_FILE contents"
  MQTT_PASSWORD=$(cat ${MQTT_PASSWORD_FILE:-'/run/secrets/mqtt_password'})
fi

echo "Starting rtl_433_mqtt_hass.py..."
echo "Running: python3 -u /rtl_433_mqtt_hass.py -d -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -H ${MQTT_HOST} -D ${DISCOVERY_PREFIX} -R ${RTL_TOPIC}"
python3 -u /rtl_433_mqtt_hass.py -d -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -H ${MQTT_HOST} -D ${DISCOVERY_PREFIX} -R ${RTL_TOPIC}
