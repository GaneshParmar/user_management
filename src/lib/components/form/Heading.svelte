<script>
    export let heading_size = "1"; // Set the default heading level or export it
  
    // Define the text sizes for different heading levels
    const textSize = {
      "1": "text-3xl", // H1 size
      "2": "text-2xl", // H2 size
      "3": "text-xl",  // H3 size
      "4": "text-lg"   // Add text size for heading level 4
    };
  
    // Reactive statement to compute the text size based on the heading level
    $: text_size = textSize[heading_size];
  </script>
  <h1 class={`text-center font-bold ${text_size}`}>
    <slot /> 
  </h1>
  
  <style>
    /* You can add more custom styles here if needed */
  </style>
  