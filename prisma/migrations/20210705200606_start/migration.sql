-- CreateEnum
CREATE TYPE "authentication_status_enum" AS ENUM ('ONLINE', 'OFFLINE', 'LOCKED', 'INACTIVE');

-- CreateTable
CREATE TABLE "accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "authentication_id" UUID,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "authentications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "account_id" UUID NOT NULL,
    "sessions_number" INTEGER NOT NULL DEFAULT 1,
    "password" TEXT NOT NULL,
    "failed_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked" BOOLEAN NOT NULL DEFAULT false,
    "status" "authentication_status_enum" NOT NULL DEFAULT E'OFFLINE',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "auth_groups_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "authentication__sessions" (
    "authentication_id" UUID NOT NULL,
    "session_id" UUID NOT NULL,

    PRIMARY KEY ("authentication_id","session_id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ip" TEXT NOT NULL,
    "device" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_groups" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "active" BOOLEAN NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_groups__permissions" (
    "auth_group_id" UUID NOT NULL,
    "permission_id" TEXT NOT NULL,

    PRIMARY KEY ("auth_group_id","permission_id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "name" TEXT NOT NULL,
    "action" TEXT[],

    PRIMARY KEY ("name")
);

-- CreateIndex
CREATE UNIQUE INDEX "accounts.email_unique" ON "accounts"("email");

-- AddForeignKey
ALTER TABLE "authentications" ADD FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentications" ADD FOREIGN KEY ("auth_groups_id") REFERENCES "auth_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentication__sessions" ADD FOREIGN KEY ("authentication_id") REFERENCES "authentications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentication__sessions" ADD FOREIGN KEY ("session_id") REFERENCES "sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_groups__permissions" ADD FOREIGN KEY ("auth_group_id") REFERENCES "auth_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_groups__permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions"("name") ON DELETE CASCADE ON UPDATE CASCADE;
