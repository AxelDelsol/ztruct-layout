const std = @import("std");
const Problem = @import("problem.zig");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const data =
        \\{
        \\  "types": [
        \\      { "name": "u8", "size": 1, "alignment": 1  },
        \\      { "name": "i32", "size": 4, "alignment": 4  }
        \\  ] 
        \\}
    ;

    var parser = Problem.Parser.init(allocator);
    defer parser.deinit();

    const problem = try parser.fromJsonLeaky(data);

    std.debug.print("Problem : {any} .\n", .{problem});
}

test {
    _ = Problem;
}
