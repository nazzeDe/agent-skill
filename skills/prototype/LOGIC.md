# Logic Prototype

Build a small interactive terminal program when a state model, transition rule, data shape, or API usage needs executable evidence.

## Shape

1. Write the question at the top of the prototype.
2. Use the repository's language and runtime.
3. Isolate the model behind the smallest fitting form: a reducer, explicit state machine, pure functions, or a stateful module only when state is intrinsic.
4. Keep model logic independent from terminal input and rendering.
5. Redraw the complete relevant state after each action and show a compact command list.
6. Add one repository-standard command to run it.

Use memory state unless persistence is the question. Do not add production I/O, broad error handling, speculative capability, or prototype tests.

## Evaluation And Cleanup

Let the user drive boundary sequences and record the approved state rules, invalid operations, and expected outcomes. Keep the prototype runnable until the formal implementation has been written from scratch and validated against those outcomes. Then delete the prototype; do not move its reducer, state machine, or helper code directly into production.
