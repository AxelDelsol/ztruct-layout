const std = @import("std");
const Self = @This();

const Problem = @import("../Problem.zig");
const Type = Problem.Type;

arena: std.heap.ArenaAllocator,

pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .arena = std.heap.ArenaAllocator.init(allocator) };
}

pub fn deinit(self: Self) void {
    self.arena.deinit();
}

pub fn fromJsonLeaky(self: *Self, data: []const u8) !Problem {
    const parsed = try std.json.parseFromSliceLeaky(
        struct { types: []const Type },
        self.arena.allocator(),
        data,
        .{},
    );

    return .{ .types = parsed.types };
}

test "parse types" {
    const allocator = std.testing.allocator;

    const data =
        \\{
        \\  "types": [
        \\      { "name": "u8", "size": 1, "alignment": 1  },
        \\      { "name": "i32", "size": 4, "alignment": 4  }
        \\  ] 
        \\}
    ;

    var parser = Self.init(allocator);
    defer parser.deinit();

    const problem = try parser.fromJsonLeaky(data);

    const expected: Problem = .{ .types = &[_]Type{
        .{ .name = "u8", .size = 1, .alignment = 1 },
        .{ .name = "i32", .size = 4, .alignment = 4 },
    } };

    try std.testing.expectEqualDeep(expected, problem);
}
