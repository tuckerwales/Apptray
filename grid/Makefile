SDKVERSION = 8.2
ARCHS = armv7 arm64
include theos/makefiles/common.mk

LIBRARY_NAME = libgrid
libgrid_FILES = UICollectionView+Draggable.m DraggableCollectionViewFlowLayout.m LSCollectionViewHelper.m LSCollectionViewLayoutHelper.m
libgrid_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
