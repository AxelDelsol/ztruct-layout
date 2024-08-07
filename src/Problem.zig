const std = @import("std");
const Self = @This();

pub const Parser = @import("Problem/Parser.zig");
pub const Type = struct { name: []const u8, size: usize, alignment: usize };

types: []const Type,

test {
    std.testing.refAllDecls(@This());
}
