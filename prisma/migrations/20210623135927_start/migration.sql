-- CreateExtensions 

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- CreateEnum
CREATE TYPE "authentication_status_enum" AS ENUM ('ONLINE', 'OFFLINE', 'LOCKED', 'INACTIVE');

-- CreateTable
CREATE TABLE "accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "authenticationId" UUID,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "lastName" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "authentications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "accountsId" UUID NOT NULL,
    "sessionsNumber" INTEGER NOT NULL DEFAULT 1,
    "password" TEXT NOT NULL,
    "failedAttempts" INTEGER NOT NULL DEFAULT 0,
    "locked" BOOLEAN NOT NULL DEFAULT false,
    "status" "authentication_status_enum" NOT NULL DEFAULT E'OFFLINE',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "auth_groupsId" UUID NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "authentication__session" (
    "authenticationId" UUID NOT NULL,
    "sessionId" UUID NOT NULL,

    PRIMARY KEY ("authenticationId","sessionId")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ip" TEXT NOT NULL,
    "device" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_groups" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "active" BOOLEAN NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_groups__permissions" (
    "authGroupId" UUID NOT NULL,
    "permissionsId" TEXT NOT NULL,

    PRIMARY KEY ("authGroupId","permissionsId")
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
ALTER TABLE "authentications" ADD FOREIGN KEY ("accountsId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentications" ADD FOREIGN KEY ("auth_groupsId") REFERENCES "auth_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentication__session" ADD FOREIGN KEY ("authenticationId") REFERENCES "authentications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "authentication__session" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_groups__permissions" ADD FOREIGN KEY ("authGroupId") REFERENCES "auth_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_groups__permissions" ADD FOREIGN KEY ("permissionsId") REFERENCES "permissions"("name") ON DELETE CASCADE ON UPDATE CASCADE;
