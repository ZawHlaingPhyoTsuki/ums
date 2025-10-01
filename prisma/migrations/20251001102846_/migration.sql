-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('Tenant', 'Admin', 'Staff');

-- CreateEnum
CREATE TYPE "RoomStatus" AS ENUM ('Available', 'Rented', 'Purchased', 'InMaintenance');

-- CreateEnum
CREATE TYPE "Category" AS ENUM ('Complain', 'Maintenance', 'Other');

-- CreateEnum
CREATE TYPE "ServiceStatus" AS ENUM ('Pending', 'Ongoing', 'Resolved');

-- CreateEnum
CREATE TYPE "PriorityLevel" AS ENUM ('Low', 'Medium', 'High');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('Overdue', 'Paid', 'Pending');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('Cash', 'Mobile_Banking');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "user_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "refresh_token" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" TEXT NOT NULL,
    "room_no" INTEGER NOT NULL,
    "floor" INTEGER NOT NULL,
    "dimension" TEXT NOT NULL,
    "no_of_bed_room" INTEGER NOT NULL,
    "status" "RoomStatus" NOT NULL DEFAULT 'Available',
    "selling_price" DECIMAL(65,30),
    "max_no_of_people" INTEGER NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tenants" (
    "id" TEXT NOT NULL,
    "names" TEXT[],
    "emails" TEXT[],
    "nrcs" TEXT[],
    "phone_nos" TEXT[],
    "emergency_nos" TEXT[],
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "room_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "tenants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contract_types" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "facilities" TEXT[],
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "contract_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contracts" (
    "id" TEXT NOT NULL,
    "contract_id" TEXT NOT NULL,
    "expiry_date" TIMESTAMP(3) NOT NULL,
    "created_date" TIMESTAMP(3) NOT NULL,
    "updated_date" TIMESTAMP(3) NOT NULL,
    "room_id" TEXT NOT NULL,

    CONSTRAINT "contracts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_services" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" "Category" NOT NULL,
    "status" "ServiceStatus" NOT NULL,
    "priority_level" "PriorityLevel" NOT NULL,
    "issue_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "room_id" TEXT NOT NULL,

    CONSTRAINT "customer_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bills" (
    "id" TEXT NOT NULL,
    "rental_fee" DECIMAL(65,30) NOT NULL,
    "electricity_fee" DECIMAL(65,30) NOT NULL,
    "water_fee" DECIMAL(65,30) NOT NULL,
    "fine_fee" DECIMAL(65,30),
    "service_fee" DECIMAL(65,30) NOT NULL,
    "ground_fee" DECIMAL(65,30) NOT NULL,
    "car_parking_fee" DECIMAL(65,30),
    "wifi_fee" DECIMAL(65,30),
    "total_amount" DECIMAL(65,30) NOT NULL,
    "due_date" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "room_id" TEXT NOT NULL,

    CONSTRAINT "bills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "total_units" (
    "id" TEXT NOT NULL,
    "electricity_units" DECIMAL(65,30) NOT NULL,
    "water_units" DECIMAL(65,30) NOT NULL,
    "created_at" DECIMAL(65,30) NOT NULL,
    "bill_id" TEXT NOT NULL,

    CONSTRAINT "total_units_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" TEXT NOT NULL,
    "status" "InvoiceStatus" NOT NULL,
    "bill_id" TEXT NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "receipts" (
    "id" TEXT NOT NULL,
    "payment_method" "PaymentMethod" NOT NULL,
    "invoice_id" TEXT NOT NULL,

    CONSTRAINT "receipts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "rooms_room_no_key" ON "rooms"("room_no");

-- CreateIndex
CREATE UNIQUE INDEX "tenants_room_id_key" ON "tenants"("room_id");

-- CreateIndex
CREATE UNIQUE INDEX "tenants_user_id_key" ON "tenants"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "contracts_room_id_key" ON "contracts"("room_id");

-- CreateIndex
CREATE UNIQUE INDEX "bills_room_id_key" ON "bills"("room_id");

-- CreateIndex
CREATE UNIQUE INDEX "total_units_bill_id_key" ON "total_units"("bill_id");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_bill_id_key" ON "invoices"("bill_id");

-- CreateIndex
CREATE UNIQUE INDEX "receipts_invoice_id_key" ON "receipts"("invoice_id");

-- AddForeignKey
ALTER TABLE "tenants" ADD CONSTRAINT "tenants_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tenants" ADD CONSTRAINT "tenants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_contract_id_fkey" FOREIGN KEY ("contract_id") REFERENCES "contract_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_services" ADD CONSTRAINT "customer_services_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bills" ADD CONSTRAINT "bills_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "total_units" ADD CONSTRAINT "total_units_bill_id_fkey" FOREIGN KEY ("bill_id") REFERENCES "bills"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_bill_id_fkey" FOREIGN KEY ("bill_id") REFERENCES "bills"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipts" ADD CONSTRAINT "receipts_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
