#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/AlipaySDK-iOS/AlipaySDK.bundle"
  install_resource "${PODS_ROOT}/BRPickerView/BRPickerView/AddressPickerView/BRPickerView.bundle"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/alert_failed_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_ Focusing@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_camera_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_camera_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_close@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_close_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_drop_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_auto@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_auto_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_open@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_open_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_image_capture_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_overturn@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_overturn_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_tag_dot_white@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_video_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_video_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_delete@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_gifbutton_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_gifbutton_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_default@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_default@2x副本.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_right@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_background@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_close_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_close_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_only_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_only_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_filter_checkbox_checked@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_original@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_original_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_photograph@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_photograph_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_right@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_seleted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_video@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_video_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_pic_add@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/feed_more_arrow@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/headlines_icon_arrow@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/hotweibo_back_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/icon_jixu@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/icon_shanchu@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/multimedia_videocard_play@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/page_score_pic_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/timeline_image_gif@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/VideoSendIcon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_button@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_button_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_dustbin@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button_disabled@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/椭圆-1-拷贝@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/椭圆-1@2x.png"
  install_resource "${PODS_ROOT}/MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "${PODS_ROOT}/ProgressHUD/ProgressHUD/ProgressHUD/ProgressHUD.bundle"
  install_resource "${PODS_ROOT}/ZQPlayer/ZQPlayer/ZQPlayerImage.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/AlipaySDK-iOS/AlipaySDK.bundle"
  install_resource "${PODS_ROOT}/BRPickerView/BRPickerView/AddressPickerView/BRPickerView.bundle"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/alert_failed_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_ Focusing@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_camera_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_camera_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_close@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_close_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_drop_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_auto@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_auto_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_open@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_flashlight_open_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_image_capture_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_overturn@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_overturn_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_tag_dot_white@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_video_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/camera_video_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_delete@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_gifbutton_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_gifbutton_background_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_default@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_default@2x副本.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_guide_check_box_right@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_background@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_close_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_close_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_only_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_live_photo_open_only_icon@3x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_filter_checkbox_checked@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_original@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_original_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_photograph@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_photograph_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_disable@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_right@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_preview_seleted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_video@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_photo_video_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/compose_pic_add@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/feed_more_arrow@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/headlines_icon_arrow@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/hotweibo_back_icon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/icon_jixu@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/icon_shanchu@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/multimedia_videocard_play@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/page_score_pic_background@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/timeline_image_gif@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/VideoSendIcon@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_button@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_button_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_delete_dustbin@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button_disabled@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/video_next_button_highlighted@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/椭圆-1-拷贝@2x.png"
  install_resource "${PODS_ROOT}/HXWeiboPhotoPicker/微博照片选择/HXWeiboPhotoPicker/images/椭圆-1@2x.png"
  install_resource "${PODS_ROOT}/MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "${PODS_ROOT}/ProgressHUD/ProgressHUD/ProgressHUD/ProgressHUD.bundle"
  install_resource "${PODS_ROOT}/ZQPlayer/ZQPlayer/ZQPlayerImage.bundle"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
