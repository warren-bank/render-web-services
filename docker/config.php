<?php

if (!isset($_ENV["REDIS_HOST"]))
  die("Required environment variable is not defined: REDIS_HOST\n");
if (!isset($_ENV["REDIS_PORT"]))
  die("Required environment variable is not defined: REDIS_PORT\n");
if ((get_auth_method() == PASSWORD) && !isset($_ENV["PASSWORD_HASH"]))
  die("Required environment variable is not defined: PASSWORD_HASH\n");
if (!isset($_ENV["PUBLIC_URL"]))
  die("Required environment variable is not defined: PUBLIC_URL\n");

function get_auth_method() {
    return (
        isset($_ENV["AUTH_METHOD"]) &&
        (strcmp($_ENV["AUTH_METHOD"], "HTPASSWD") == 0)
    ) ? HTPASSWD : PASSWORD;
}

function get_velocity_unit() {
    if (!isset($_ENV["VELOCITY_UNIT"]))
        return MILES_PER_HOUR;
    else if (strcmp($_ENV["VELOCITY_UNIT"], "METERS_PER_SECOND") == 0)
        return METERS_PER_SECOND;
    else if (strcmp($_ENV["VELOCITY_UNIT"], "KILOMETERS_PER_HOUR") == 0)
        return KILOMETERS_PER_HOUR;
    else
        return MILES_PER_HOUR;
}

const CONFIG = array(
    "storage_backend"       => REDIS,
    "redis_host"            => constant($_ENV["REDIS_HOST"]),
    "redis_port"            => constant($_ENV["REDIS_PORT"]),
    "redis_use_auth"        => false,
    "redis_auth"            => '',
    "redis_prefix"          => 'hauk',
    "auth_method"           => constant(get_auth_method()),
    "password_hash"         => constant($_ENV["PASSWORD_HASH"]),
    "velocity_unit"         => constant(get_velocity_unit()),
    "public_url"            => constant($_ENV["PUBLIC_URL"])
);
