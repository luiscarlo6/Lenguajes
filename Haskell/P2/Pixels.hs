import qualified Data.Map
import qualified Graphics.HGL

data Pixels = Pixels { color ::  Graphics.HGL.Color, dots ::[[Pixel]] }

data Pixel = Pixel { on :: Bool }
