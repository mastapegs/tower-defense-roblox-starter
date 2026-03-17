-- Type definitions for TestEZ globals injected into .spec modules.
-- These are provided at runtime by the TestEZ framework; this file
-- tells luau-lsp about them so strict mode doesn't complain.

declare function describe(name: string, callback: () -> ()): ()
declare function it(name: string, callback: () -> ()): ()
declare function expect(value: any): any
declare function FIXME(optionalMessage: string?): ()
declare function FOCUS(): ()
declare function SKIP(): ()
