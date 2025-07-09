<?php
header("Access-Control-Allow-Origin: *"); // Allows requests from any origin
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); // Specifies allowed methods
header("Access-Control-Allow-Headers: Content-Type"); // Specifies allowed headers

// File path to store the text
$file = __DIR__ . '/vaaniy_speech_input';

// Function to format the text with newlines
function formatText($text) {
    // Regex to add newlines after punctuation (!, ?, .) 
    // ensuring not to split decimal numbers or filenames
    $formatted = preg_replace_callback(
        '/([.!?])(?=\s|$)(?!\.\s?[a-zA-Z]{2,4})/', // Match punctuation not followed by file extensions or decimals
        function ($matches) {
            return $matches[1] . PHP_EOL;
        },
        $text
    );

    // Append a newline and space at the end
    $formatted = rtrim($formatted) . PHP_EOL . ' ';

    return $formatted;
}

// Check if data was sent via POST
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['text'])) {
    // Get the text from POST data
    $text = trim($_POST['text']);
    
    // Format the text
    $formattedText = formatText($text);

    // Overwrite the file with the formatted text
    if (file_put_contents($file, $formattedText)) {
        // Respond with "OK" instead of the received text
        echo "OK";
    } else {
        echo "Failed to write to file.";
    }
} else {
    // Display instructions for using the script
    echo "Send a POST request with 'text' parameter to save data.";
}
?>

