SHELL := /bin/bash

.PHONY: build clean set-pipeline upload 

clean:
	rm -rf .esphome device.yaml firmware.bin secrets.yaml

secrets.yaml: ../secrets-template.yaml
	ytt \
		--file ../secrets-template.yaml \
		--data-value-file wifi.ssid=<(op read "op://Private/Home WiFi/network name") \
		--data-value-file wifi.password=<(op read "op://Private/Home WiFi/wireless network password") \
		> secrets.yaml

device.yaml: data.yaml secrets.yaml ../template.yaml ../lib/i2c-overlay.yaml ../lib/sht30-overlay.yaml version
	ytt \
		--file ../template.yaml \
		--file ../lib/i2c-overlay.yaml \
		--file ../lib/sht30-overlay.yaml \
		--data-value-file version=version \
		--data-values-file secrets.yaml \
		--data-values-file <(ytt -f data.yaml --data-value-file version=version) \
		> device.yaml

firmware.bin: device.yaml
	esphome compile device.yaml
	cp .esphome/build/office/.pioenvs/office/firmware.bin firmware.bin

build: firmware.bin

upload: firmware.bin
	esphome upload device.yaml
