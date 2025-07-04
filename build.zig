const std = @import("std");

pub fn build(b: *std.Build) !void {
    // Import dependency.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Prepare the build of the static library.
    const jwasm = b.addExecutable(.{
        .name = "jwasm",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    jwasm.linkLibC();

    var flags = std.ArrayList([]const u8).init(b.allocator);

    if (target.result.os.tag == .linux) {
        try flags.append("-D__UNIX__");
    }

    for (jwasm_src) |src| {
        jwasm.addCSourceFile(.{
            .file = b.path(src),
            .flags = flags.items,
            .language = .c,
        });
    }

    jwasm.addIncludePath(b.path("src/H"));

    b.installArtifact(jwasm);
}

// The Windows specific source files.
pub const jwasm_src: []const []const u8 = &.{
    "src/main.c",
    "src/apiemu.c",
    "src/assemble.c",
    "src/assume.c",
    "src/atofloat.c",
    "src/backptch.c",
    "src/bin.c",
    "src/branch.c",
    "src/cmdline.c",
    "src/codegen.c",
    "src/coff.c",
    "src/condasm.c",
    "src/context.c",
    "src/cpumodel.c",
    "src/data.c",
    "src/dbgcv.c",
    "src/directiv.c",
    "src/elf.c",
    "src/end.c",
    "src/equate.c",
    "src/errmsg.c",
    "src/expans.c",
    "src/expreval.c",
    "src/extern.c",
    "src/fastpass.c",
    "src/fixup.c",
    "src/fpfixup.c",
    "src/hll.c",
    "src/input.c",
    "src/invoke.c",
    "src/label.c",
    "src/linnum.c",
    "src/listing.c",
    "src/loop.c",
    "src/lqueue.c",
    "src/macro.c",
    "src/mangle.c",
    "src/memalloc.c",
    "src/msgtext.c",
    "src/omf.c",
    "src/omffixup.c",
    "src/omfint.c",
    "src/option.c",
    "src/parser.c",
    "src/posndir.c",
    "src/preproc.c",
    "src/proc.c",
    "src/queue.c",
    "src/reswords.c",
    "src/safeseh.c",
    "src/segment.c",
    "src/simsegm.c",
    "src/string.c",
    "src/symbols.c",
    "src/tbyte.c",
    "src/tokenize.c",
    "src/trmem.c",
    "src/types.c",
};
