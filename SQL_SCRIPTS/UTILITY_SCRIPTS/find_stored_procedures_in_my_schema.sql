SELECT
    mysql.proc.name,
    mysql.proc.type,
    mysql.proc.language,
    mysql.proc.is_deterministic
FROM mysql.proc
WHERE mysql.proc.db='innodb_profiling';
