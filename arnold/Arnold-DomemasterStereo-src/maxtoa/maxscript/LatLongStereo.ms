-- LatLong Stereoscopic Lens Shader Arnold MAXtoA Scripted Controller
-- 2016-12-30 11.34 PM
-- by Andrew Hazelden andrew@andrewhazelden.com and Roberto Ziche
-- -------------------------------------------------------------------
-- Todo: Customize the classid node setting line: classID:#(515151,676100)
-- 
-- NOTE: This script requires the "Domemaster3D" lens shader DLL that can be downloaded from:
-- https://github.com/zicher3d-org/domemaster-stereo-shader/
-- -------------------------------------------------------------------

plugin Camera arnold_latlong_stereo_camera
extends:FreeCamera
name:"LatLongStereo Cam"
classID:#(515151,676100)
category:"Arnold"
replaceUI:true
(
  parameters main rollout:params
  (
    arnold_node type:#string default:"LatLongStereo"
    
    -- Center/Left/Right dropdown
    arnold_node_camera              type:#integer             default:1   ui:camera_sel
    
    -- Valid range 0.1-180 degrees
    arnold_node_fov_vert_angle      type:#float               default:180 ui:fov_vert_angle
    
    -- Valid range 0.1-360 degrees
    arnold_node_fov_horiz_angle     type:#float               default:360 ui:fov_horiz_angle
    
    -- These two controls are set in scene coordinates (typically expressed visually in cm for stereographers)
    arnold_node_parallax_distance   type:#worldunits          default:(units.decodeValue("10m"))  ui:parallax_distance
    arnold_node_separation          type:#worldunits          default:(units.decodeValue("65mm")) ui:separation

    -- Checkboxes
    arnold_node_zenith_mode         type:#integer             default:0   ui:zenith_mode
    
    -- These three controls need to be turned into mappable image selection fields
    arnold_node_separation_map      type:#float               default:1   ui:separation_map
    arnold_node_head_tilt_map       type:#float               default:0.5 ui:head_tilt_map
    
    -- Checkboxes
    arnold_node_flip_ray_x          type:#integer             default:0   ui:flip_ray_x
    arnold_node_flip_ray_y          type:#integer             default:0   ui:flip_ray_y
  )
  
  -- Hack to touch a parameter that the camera translator "cares" about to 
  -- trigger a retranslation. Ugly, but.... works for now :D
  fn forceUpdate = 
  (
    if delegate.fov == 160 then delegate.fov = 160.001 else delegate.fov = 160    
  )
  
  rollout params "DomemasterStereo Shader Parameters"
  (
    dropdownlist camera_sel         "Camera" items:#("Center","Left", "Right")
    spinner fov_vert_angle          "Field of View Vertical" 
    spinner fov_horiz_angle         "Field of View Horizontal" 
    spinner parallax_distance       "Zero Parallax Distance"  type:#worldunits
    spinner separation              "Camera Separation"       type:#worldunits
    checkbutton zenith_mode         "Zenith Mode"
    spinner separation_map          "Separation Map"
    spinner head_tilt_map           "Head Tilt Map"
    checkbutton flip_ray_x          "Flip X"
    checkbutton flip_ray_y          "Flip Y"
    
    
    -- This is a workaround for the camera being too smart, and ignoring any
    -- updates that are not in its set of "parameters I care about"
    
    -- Note: dropdownlists use "selected" and spinners use "changed"
    
    on camera_sel                   selected val do forceUpdate()
    on fov_vert_angle               changed val do forceUpdate()
    on fov_horiz_angle              changed val do forceUpdate()
    on parallax_distance            changed val do forceUpdate()
    on separation                   changed val do forceUpdate()
    on zenith_mode                  changed val do forceUpdate()
    on separation_map               changed val do forceUpdate()
    on head_tilt_map                changed val do forceUpdate()
    on flip_ray_x                   changed val do forceUpdate()
    on flip_ray_y                   changed val do forceUpdate()    
  )
)
