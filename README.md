# Vector.lua
A Vector class

### Example:
![image](https://user-images.githubusercontent.com/34854689/210561252-46a0deac-1939-4550-959b-8803a8aea8e6.png)

```lua
local mins = Vector(13, 50)
mins.abscissa = 17 -- alias support
mins.ord = 53

local maxs = Vector(75, 25)
maxs.x = 46
maxs[2] = 28

print(
	"from incredible-gmod.ru with <3",
	"\n\t".. mins,
	"\n\t meta events: ".. mins + (maxs - mins) * 0.5,
	"\n\t 5.3 events support (even in lua 5.1): ".. #mins,
	"\n\t normal: ".. mins:GetNormal(),
	"\n\t distance: ".. mins:Distance(maxs),
	"\n\t distance to square: ".. mins:DistanceToSqr(maxs),
	"\n\t dot product: ".. mins:Dot(maxs),
	"\n\t angle: ".. mins:Angle(maxs),
	"\n\t lerp: ".. mins:Lerp(0.5, maxs),
	"\n\t approach: ".. mins:Approach(50, maxs),
	"\nand alot of more useful things!"
)
```
