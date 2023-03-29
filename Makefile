SHELL := /bin/bash

.PHONY: build clean upload 

clean:
	rm -rf .esphome device.yaml firmware.bin

device.yaml: device-data.yaml device-template.yaml version
	ytt \
		--file device-template.yaml \
		--data-values-file <(ytt -f device-data.yaml --data-value-file version=version) \
		--data-value-file wifi.ssid=<(op read "op://Private/Home WiFi/network name") \
		--data-value-file wifi.password=<(op read "op://Private/Home WiFi/wireless network password") \
		> device.yaml

firmware.bin: device.yaml
	esphome compile device.yaml
	cp .esphome/build/base-$(shell sed -e "s/\./-/g" version)/.pioenvs/base-$(shell sed -e "s/\./-/g" version)/firmware.bin firmware.bin

build: firmware.bin

upload: firmware.bin
	esphome upload device.yaml

