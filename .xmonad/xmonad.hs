import XMonad
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as W

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

myKeys =
     [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "wer" [0,2,1] -- was [0..] *** change to match your screen order ***
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
     ]

-- origKeys = [ ((controlMask, xK_space), spawn "xdotool click 2") ]

main = xmonad $ def
    { terminal = "alacritty",
      startupHook = setWMName "LG3D",
      layoutHook = myLayout }
    `additionalKeysP` myKeys
