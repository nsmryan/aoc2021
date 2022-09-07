const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub const SPair = struct {
    first: SNum,
    second: SNum,
};

pub const SNum = union(enum) {
    num: usize,
    split: *SPair,
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var snum = SNum{ .num = 10 };
    try reduceSNum(&snum, allocator);
    printSNum(&snum);
}

pub fn printSNum(snum: *SNum) void {
    switch (snum.*) {
        .num => |n| {
            std.debug.print("{}, ", .{n});
        },

        .split => |pair| {
            std.debug.print("[", .{});
            printSNum(&pair.first);
            printSNum(&pair.second);
            std.debug.print("] ", .{});
        },
    }
}

pub fn reduceSNum(snum: *SNum, allocator: Allocator) !void {
    var rights = ArrayList(SNum).init(allocator);
    var lefts = ArrayList(SNum).init(allocator);
    while (try reduceSNumHelper(snum, 0, &rights, &lefts, allocator)) {}
}

pub fn reduceSNumHelper(snum: *SNum, depth: usize, rights: *ArrayList(SNum), lefts: *ArrayList(SNum), allocator: Allocator) !bool {
    if (depth >= 4 and snum.* == .split and snum.*.split.first == .num and snum.*.split.second == .num) {
        // explode the left pair
        std.debug.print("explode\n", .{});
        addToFirstRegular(lefts, snum.split.first.num);
        addToFirstRegular(rights, snum.split.second.num);
        allocator.free(snum.split);
        snum.* = SNum{ .num = 0 };
        return true;
    } else if (snum.* == .num and snum.*.num >= 10) {
        // split the left pair
        std.debug.print("split\n", .{});
        const value = snum.num;
        const over2Down = value / 2;
        var over2Up = over2Down;
        if (value % 2 != 0) {
            over2Up += 1;
        }

        var spair: *SPair = try allocator.create(SPair);
        spair.* = SPair{ .first = SNum{ .num = over2Down }, .second = SNum{ .num = over2Up } };
        snum.* = SNum{ .split = spair };

        return true;
    } else if (snum.* == .split) {
        std.debug.print("recurse\n", .{});
        try rights.append(snum.split.second);
        const reduced_left = try reduceSNumHelper(&snum.split.first, depth + 1, rights, lefts, allocator);
        _ = rights.pop();
        if (!reduced_left) {
            try lefts.append(snum.split.first);
            const reduced_right = try reduceSNumHelper(&snum.split.second, depth + 1, rights, lefts, allocator);
            _ = rights.pop();
            return reduced_right;
        } else {
            return reduced_left;
        }
    } else {
        std.debug.print("done\n", .{});
        return false;
    }
}

pub fn addToFirstRegular(branches: *ArrayList(SNum), value: usize) void {
    if (branches.items.len > 0) {
        var branch = &branches.items[branches.items.len - 1];
        _ = findAndAdd(branch, value);
    }
}

pub fn findAndAdd(snum: *SNum, value: usize) bool {
    switch (snum.*) {
        .num => {
            snum.*.num += value;
            return true;
        },

        .split => {
            var found = findAndAdd(&snum.split.*.first, value);
            if (!found) {
                found = findAndAdd(&snum.split.*.second, value);
            }
            return found;
        },
    }
}

test {
    var allocator = std.heap.page_allocator;
    var snum = SNum{ .num = 10 };
    try reduceSNum(&snum, allocator);
    printSNum(&snum);
}
