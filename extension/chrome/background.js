chrome.runtime.onInstalled.addListener(() => {
    // Remove existing context menu items to avoid duplicates
    chrome.contextMenus.removeAll(() => {
        // Create the context menu item
        chrome.contextMenus.create({
            id: "speakWithVaaniy",
            title: "Speak with Vaaniy",
            contexts: ["selection"] // Show this option only when text is selected
        });
    });
});

// Add a listener for the context menu click
chrome.contextMenus.onClicked.addListener((info, tab) => {
    if (info.menuItemId === "speakWithVaaniy" && info.selectionText) {
        const selectedText = info.selectionText.trim();
        if (selectedText) {
            // Send the text to your API
            fetch("http://www.vaaniy.com:8080/vaaniy_api.php", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ text: selectedText })
            })
                .then(response => response.text())
                .then(result => {
                    console.log("Response from server:", result);
                })
                .catch(error => {
                    console.error("Error sending text to server:", error);
                });
        }
    }
});

