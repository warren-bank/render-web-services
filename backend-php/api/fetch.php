<?php

// This script is called by the client to receive location updates. A link ID is
// required to retrieve data.

include("../include/inc.php");
header("X-Hauk-Version: ".BACKEND_VERSION);

foreach (array("id") as $field) if (!isset($_GET[$field])) die($LANG['session_invalid']."\n");

$memcache = memConnect();

// Get the share from the given share ID.
$share = Share::fromShareID($memcache, $_GET["id"]);

// If the link data key is not set, the session probably expired.
if (!$share->exists()) {
    header("HTTP/1.1 404 Not Found");
    die($LANG['session_invalid']."\n");
} else {
    header("Content-Type: text/json");

    $sinceTime=$_GET["since"] ?? null;

    // Solo and group shares have different internal structures. Figure out the
    // correct type so that it can be output.
    switch ($share->getType()) {
        case SHARE_TYPE_ALONE:
            $session = $share->getHost();
            if (!$session->exists()) {
                header("HTTP/1.1 404 Not Found");
                die($LANG['session_invalid']."\n");
            }
            echo json_encode(array(
                "type" => $share->getType(),
                "expire" => $share->getExpirationTime(),
                "serverTime" => microtime(true),
                "interval" => $session->getInterval(),
                "points" => $session->getPoints($sinceTime),
                "encrypted" => $session->isEncrypted(),
                "salt" => $session->getEncryptionSalt()
            ));
            break;

        case SHARE_TYPE_GROUP:
            echo json_encode(array(
                "type" => $share->getType(),
                "expire" => $share->getExpirationTime(),
                "serverTime" => microtime(true),
                "interval" => $share->getAutoInterval(),
                "points" => $share->getAllPoints($sinceTime)
            ));
            break;
    }
}

echo "\n";
