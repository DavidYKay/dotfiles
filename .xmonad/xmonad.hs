import XMonad
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName

myLayout = tiled ||| Mirror tiled ||| spiral (6/7) ||| mosaic 2 [3,2] ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

main = xmonad $ def
    { terminal = "gnome-terminal",
      startupHook = setWMName "LG3D",
      layoutHook = myLayout }
    `additionalKeys`
     [ ((controlMask, xK_space), spawn "xdotool click 2") ]
