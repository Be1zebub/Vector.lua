-- from russia with love <3
-- incredible-gmod.ru
-- https://github.com/Be1zebub/Vector.lua

local Vector = {MetaName = "Vector"}

local storage = setmetatable({}, {__mode = "k"})

setmetatable(Vector, {__call = function(_, x, y, z)
	local instance = newproxy(true)
	debug.setmetatable(instance, Vector)

	storage[instance] = {}
	instance:SetUnpacked(x, y, z)

	return instance
end})

function Vector:Remove()
	storage[self] = nil
end

function IsVector(var)
	return getmetatable(var) == Vector
end

local alias_map = {
	x = 1, y = 2, z = 3,
	[1] = 1, [2] = 2, [3] = 3,
	abs = 1, ord = 2, app = 3,
	abscissa = 1, ordinate = 2, applicate = 3
}

function Vector:__index(axis_or_method)
	local method = Vector[axis_or_method]
	if method then return method end

	local index = alias_map[axis_or_method]
	if index == nil then return end

	return storage[self][index] or 0
end

function Vector:__newindex(axis, value)
	axis = alias_map[axis]
	if axis == nil then return end

	storage[self][axis] = value
end

function Vector:__tostring()
	if self.z == 0 and self.y == 0 then return (string.format("Vector(%s)", self.x):gsub("^%.?(0+)", "")) end
	if self.z == 0 then return (string.format("Vector(%s, %s)", self.x, self.y):gsub("^%.?(0+)", "")) end
	return (string.format("Vector(%s, %s, %s)", self.x, self.y, self.z):gsub("^%.?(0+)", ""))
end

function Vector:__concat(v)
	return tostring(self) .. (IsVector(v) and " ".. tostring(v) or v)
end

function Vector:__add(vec)
	return Vector(self.x + vec.x, self.y + vec.y, self.z + vec.z)
end

function Vector:__sub(vec)
	return Vector(self.x - vec.x, self.y - vec.y, self.z - vec.z)
end

function Vector:__mul(val)
	if IsVector(val) then
		return Vector(self.x * val.x, self.y * val.y, self.z * val.z)
	else
		return Vector(self.x * val, self.y * val, self.z * val)
	end
end

function Vector:__div(val)
	if IsVector(val) then
		return Vector(self.x / val.x, self.y / val.y, self.z / val.z)
	else
		return Vector(self.x / val, self.y / val, self.z / val)
	end
end

function Vector:__pow(val)
	if IsVector(val) then
		return Vector(self.x ^ val.x, self.y ^ val.y, self.z ^ val.y)
	else
		return Vector(self.x ^ val, self.y ^ val, val, self.z ^ val)
	end
end

function Vector:__eq(val)
	return IsVector(val) and self.x == val.x and self.y == val.y and self.z == val.z
end

function Vector:__unm()
	return Vector(-self.x, -self.y, -self.z)
end

function Vector:__len()
	return (self.x * self.x + self.y * self.y + self.z * self.z) ^ 0.5
end

Vector.Length = Vector.__len

function Vector:SetUnpacked(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function Vector:Unpack()
	return self.x, self.y, self.z
end

function Vector:Distance(vec)
	return (self - vec):Length()
end

function Vector:DistanceToSqr(vec)
	return (self.x - vec.x) ^ 2 + (self.y - vec.y) ^ 2 + (self.z - vec.z) ^ 2
end

function Vector:Normalize(len)
	if len then
		len = len / #self
		self.x = self.x * len
		self.y = self.y * len
		self.z = self.z * len
	else
		len = #self
		self.x = self.x / len
		self.y = self.y / len
		self.z = self.z / len
	end

	return self
end

function Vector:GetNormal()
	return self / #self
end

function Vector:Dot(vec)
	return self.x * vec.x + self.y * vec.y + self.z * vec.z
end

function Vector:GetAngle(vec)
	return math.deg(
		math.acos(self:Dot(vec) / (self:Length() * vec:Length()))
	)
end

Vector.Angle = Vector.GetAngle

local function Lerp(delta, from, to)
	if delta > 1 then return to end
	if delta < 0 then return from end

	return from + (to - from) * delta
end

function Vector:Lerp(fraction, to)
	return Vector(
		Lerp(fraction, self.x, to.x),
		Lerp(fraction, self.y, to.y),
		Lerp(fraction, self.z, to.z)
	)
end

local function Approach(cur, target, inc)
	inc = math.abs(inc)

	if cur < target then
		return math.min(cur + inc, target)
	elseif cur > target then
		return math.max(cur - inc, target)
	end

	return target
end

function Vector:Approach(change, to)
	return Vector(
		Approach(self.x, to.x, change),
		Approach(self.y, to.y, change),
		Approach(self.z, to.z, change)
	)
end

function Vector:WithInBBox(mins, maxs)
	return
		(self.x >= mins.x and self.x <= maxs.x) and
		(self.y >= mins.y and self.y <= maxs.y) and
		(self.z >= mins.z and self.z <= maxs.z)
end

function Vector:WithIn(a, b)
	return self:WithInBBox(
		{x = math.min(a.x, b.x), y = math.min(a.y, b.y), z = math.min(a.z, b.z)}, -- we could create a vector, but it's overhead - so I'll just create a table, it won't affect anything expect perf boost
		{x = math.max(a.x, b.x), y = math.max(a.y, b.y), z = math.max(a.z, b.z)}
	)
end

--[[
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
]]--

_G.Vector, _G.IsVector = Vector, IsVector
