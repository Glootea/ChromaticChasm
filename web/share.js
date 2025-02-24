function shareLink(
  url,
  title = "Check this out!",
  text = "Here's something interesting:",
) {
  if (navigator.share) {
    navigator
      .share({
        title: title,
        text: text,
        url: url,
      })
      .then(() => {
        console.log("Link shared successfully");
      })
      .catch((error) => {
        console.error("Error sharing:", error);
      });
  } else {
    console.warn("Web Share API is not supported in this browser.");
  }
}
