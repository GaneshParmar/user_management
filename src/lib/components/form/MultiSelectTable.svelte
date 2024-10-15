<script>
  import { stringify } from "uuid";
  import Button from "./Button.svelte";

  export let selected = []; // array of selected items
  export let table_data = []; // data to display in the table
  export let selectable = true; // if selection is enabled
  export let table_headings = null;

  export let showFooter = true;

  export let footerBtns = {
    Success: {
      onClick: () => {},
    },
    Cancel: {
      onClick: () => {},
    },
  };

  $: footerBtnsLabel = Object.keys(footerBtns || {}) || [];

  // Compute table headings from the first row of the table data
  $: tableHeadings = table_headings || Object.keys(table_data[0] || {}) || null;

  // Define the number of grid columns based on selectable
  $: grid_cols =
    (selectable ? tableHeadings.length * 2 + 1 : tableHeadings.length * 2) > 12
      ? 12
      : selectable
        ? tableHeadings.length * 2 + 1
        : tableHeadings.length * 2;

  // Function to handle selection
  const toggleSelection = (item) => {
    const isSelected = selected.includes(item);
    if (isSelected) {
      selected = selected.filter((i) => i !== item); // Deselect
    } else {
      selected = [...selected, item]; // Select
    }
  };

  // Function to handle "select all"
  const selectAll = () => {
    if (selected.length === table_data.length) {
      selected = []; // Deselect all
    } else {
      selected = [...table_data]; // Select all
    }
    table_data = table_data;
  };

  const isSelected = (item) => selected.includes(item);

  // Function to retrieve a nested value from an object based on a path
  function getValueFromPath(object, path, real_path) {
    try {
      // Split the path into keys (e.g., 'user.full_name' -> ['user', 'full_name'])
      const keys = path?.split(".");
      // Use reduce to traverse the object and access the nested properties
      return keys.reduce((obj, key) => (obj ? obj[key] : undefined), object);
    } catch (e) {
      console.log("Error while getValueFromPath :: ", e.message);
      return object[real_path];
    }
  }
</script>

<div class="text-gray-900 w-full">
  <div class="px-3 py-4 flex justify-center">
    <table class="w-full text-md bg-white shadow-md rounded mb-4">
      <thead >
        <tr class={`border-b grid p-2 grid-cols-5 ${"grid-cols-" + grid_cols}`}>
          {#if selectable}
            <th class="inline-flex items-center col-span-1">
              <label class="flex items-center cursor-pointer relative">
                <input
                  type="checkbox"
                  on:change={selectAll}
                  checked={selected.length === table_data.length}
                  class="peer h-5 w-5 cursor-pointer transition-all appearance-none rounded shadow hover:shadow-md border border-slate-300 checked:bg-blue-600 checked:border-blue-600"
                  id="check-all"
                />
                <span
                  class="absolute text-white opacity-0 peer-checked:opacity-100 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-3.5 w-3.5"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    stroke="currentColor"
                    stroke-width="1"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </span>
              </label>
            </th>
          {/if}
          {#each tableHeadings as heading}
            <th class="text-left py-2 px-3 col-span-2">
              {heading.split(":").length > 0
                ? heading.split(":")[0]
                : heading.toUpperCase()}
            </th>
          {/each}
        </tr>
      </thead>
      <tbody>
        {#each table_data as row}
          <tr
            class={`border-b grid p-2 grid-cols-5 ${"grid-cols-" + grid_cols} hover:bg-gray-100`}
          >
            {#if selectable}
              <td class="inline-flex items-center col-span-1">
                <label class="flex items-center cursor-pointer relative">
                  <input
                    type="checkbox"
                    on:change={() => toggleSelection(row)}
                    checked={isSelected(row)}
                    class="peer h-5 w-5 cursor-pointer transition-all appearance-none rounded shadow hover:shadow-md border border-slate-300 checked:bg-blue-600 checked:border-blue-600"
                  />
                  <span
                    class="absolute text-white opacity-0 peer-checked:opacity-100 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-3.5 w-3.5"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      stroke="currentColor"
                      stroke-width="1"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clip-rule="evenodd"
                      />
                    </svg>
                  </span>
                </label>
              </td>
            {/if}
            {#each tableHeadings as heading}
              <td class="py-2 px-3 col-span-2">
                {heading.split(":").length > 0
                  ? getValueFromPath(row, heading?.split(":")[1], heading)
                  : row[heading]}
              </td>
            {/each}
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
  {#if showFooter}
    <div class={`grid gap-2 ${"grid-cols-" + footerBtnsLabel.length}`}>
      {#each footerBtnsLabel as btnLabel}
        <div>
          <Button
            handleClick={footerBtns[btnLabel].onClick}
            variant={footerBtns[btnLabel]?.varient}
          >
            {btnLabel}
          </Button>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
</style>
