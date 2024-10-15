<script>
  export let modal = {
    error: false,
    icon: false,
    heading: "Modal Heading",
    successTxt: "Continue",
    cancelTxt: "Cancel",
    successCallback: () => {},
    cancelCallback: () => {},
    theme: "error", // success | warning | info | error
    hidefooter : false,
    dialogSize : true
  };

  export let isOpen = true; // Control the modal visibility

  const themes = {
    success: {
      bg: "bg-green",
      text: "text-white",
    },
    warning: {
      bg: "bg-yellow",
      text: "text-white",
    },
    error: {
      bg: "bg-red",
      text: "text-white",
    },
    info: {
      bg: "bg-blue",
      text: "text-white",
    },
  };

  $: {
    if (Object.keys(themes).includes(modal.theme)) {
      modal.theme = themes[modal.theme];
    }
  }

  // Function to close the modal
  const closeModal = () => {
    isOpen = false;
  };
</script>

{#if isOpen}
  <div
    class="relative z-10"
    aria-labelledby="modal-title"
    role="dialog"
    aria-modal="true"
  >
  
  <div class="fixed inset-0 z-10 w-screen overflow-y-auto ">
      <button
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
        aria-hidden="true"
        on:click={closeModal}
      ></button>
      <div
        class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
      >
        <div
          class={`relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full ${(modal.dialogSize ?? true)?'sm:max-w-lg':'sm:max-w-3xl'} `}
        >
          <div class="block bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
            <div class={`${modal.icon ? 'sm:flex': 'block'} sm:items-start`}>
              {#if modal.icon}
                <div
                  class={`mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full ${modal.theme.bg}-100 sm:mx-0 sm:h-10 sm:w-10`}
                >
                  {#if modal.error}
                    <svg
                      class="h-6 w-6 text-red-600"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"
                      />
                    </svg>
                  {/if}
                </div>
              {/if}

              <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left ">
                <h3
                  class="text-base font-semibold leading-6 text-gray-900"
                  id="modal-title"
                >
                  {modal.heading}
                </h3>
                <div class="mt-2">
                  <slot></slot>
                </div>
              </div>

              <!-- Close button (X icon) -->
              <button
                class="absolute top-2 right-2 text-gray-500 hover:text-gray-900"
                on:click={closeModal}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="2"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
          </div>

          <div class={`bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 ${modal.hidefooter ? 'invisible' :''}`}>
            <button
              type="button"
              class={`inline-flex w-full justify-center rounded-md ${modal.theme.bg}-500 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:${modal.theme.bg}-500 sm:ml-3 sm:w-auto`}
              on:click={modal.successCallback}
            >
              {modal.successTxt}
            </button>
            <button
              type="button"
              class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto"
              on:click={modal.cancelCallback}
            >
              {modal.cancelTxt}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  /* Custom styles */
</style>
