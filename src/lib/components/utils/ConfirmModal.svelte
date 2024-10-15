<script>
  import Modal from "../modal/Modal.svelte";
  export let confirm_open = true;

  export let successCallback = () => {};
  export let cancelCallback = () => {confirm_open = false};
  export let heading = null;
  export let btnLabel = {
    successTxt: "Delete",
    cancelTxt: "Close",
  };

  $: confirm_modal_config = {
    error: true,
    icon: true,
    heading: heading || `Are you sure?`,
    ...btnLabel,
    successCallback: successCallback,
    cancelCallback: cancelCallback,
    hidefooter: false,
    theme: "error",
  };
</script>

<Modal bind:isOpen={confirm_open} modal={confirm_modal_config}>
  <slot />
</Modal>

<style>
</style>
