
const showToastLoadingWhileFunctionRun = async(fn, toast, loadingTxt = "Saving...", successTxt = "Done", errorTxt = "Something went wrong!") => {
    toast.promise(fn(), {
        loading: loadingTxt,
        success: successTxt,
        error: errorTxt,
    });
}

export default showToastLoadingWhileFunctionRun;