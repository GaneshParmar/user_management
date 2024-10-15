import { deepEqual } from "./compare";

function callForOnceIfDependencyChange(fn) {
    let prevDeps = [];

    return (...currentDeps) => {
        const hasChanged = currentDeps.some(
            (dep, index) => !deepEqual(dep, prevDeps[index])
        );

        if (hasChanged) {
            console.log("Function being called since dependency changed!");
            fn();
            prevDeps = currentDeps.map((dep) =>
                typeof dep === "object" ? structuredCloneWithFallback(dep) : dep
            );
        }
    };
}

// Fallback for structuredClone if not available in all environments
function structuredCloneWithFallback(obj) {
    if (typeof structuredClone === "function") {
        return structuredClone(obj);
    } else {
        return JSON.parse(JSON.stringify(obj)); // fallback for deep cloning
    }
}

const callWhenDependencyChange = (fn, ...currentDeps) => {
    const callback = callForOnceIfDependencyChange(fn);

    // Immediately invoke the callback with current dependencies
    callback(...currentDeps);

    return callback; // Optionally return the callback to use later
};

export { callForOnceIfDependencyChange, callWhenDependencyChange };
