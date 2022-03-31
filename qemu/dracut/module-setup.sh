#!/bin/bash

check() {
	return 0
}

install() {
	inst_hook pre-pivot 90 "$moddir/vfio-iommu-gpu.sh"
}
