<?php

if (empty(getenv("REDIS_HOST", true)))
  die("Required environment variable is not defined: REDIS_HOST\n");
if (empty(getenv("REDIS_PORT", true)))
  die("Required environment variable is not defined: REDIS_PORT\n");
if ((get_auth_method() == PASSWORD) && empty(getenv("PASSWORD_HASH", true)))
  die("Required environment variable is not defined: PASSWORD_HASH\n");
if (empty(getenv("PUBLIC_URL", true)))
  die("Required environment variable is not defined: PUBLIC_URL\n");

function get_auth_method() {
    $auth_method   = getenv("AUTH_METHOD", true);
    $default_value = PASSWORD;

    if (empty($auth_method))
        return $default_value;
    else if (strcmp($auth_method, "PASSWORD") == 0)
        return PASSWORD;
    else if (strcmp($auth_method, "HTPASSWD") == 0)
        return HTPASSWD;
    else
        return $default_value;
}

function get_velocity_unit() {
    $velocity_unit = getenv("VELOCITY_UNIT", true);
    $default_value = MILES_PER_HOUR;

    if (empty($velocity_unit))
        return $default_value;
    else if (strcmp($velocity_unit, "KILOMETERS_PER_HOUR") == 0)
        return KILOMETERS_PER_HOUR;
    else if (strcmp($velocity_unit, "MILES_PER_HOUR") == 0)
        return MILES_PER_HOUR;
    else if (strcmp($velocity_unit, "METERS_PER_SECOND") == 0)
        return METERS_PER_SECOND;
    else
        return $default_value;
}

const CONFIG = array(
    "storage_backend"       => REDIS,
    "redis_host"            => constant(getenv("REDIS_HOST", true)),
    "redis_port"            => constant(getenv("REDIS_PORT", true)),
    "redis_use_auth"        => false,
    "redis_auth"            => '',
    "redis_prefix"          => 'hauk',
    "auth_method"           => constant(get_auth_method()),
    "password_hash"         => constant(getenv("PASSWORD_HASH", true)),
    "velocity_unit"         => constant(get_velocity_unit()),
    "public_url"            => constant(getenv("PUBLIC_URL", true))
);
