

-- 创建微博数据表 --

CREATE TABLE IF NOT EXISTS "T_Statuses" (
    "statusId" integer NOT NULL,
    "userId" integer NOT NULL,
    "status" text,
    "createTime" text DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY ("statusId", "userId")
);
