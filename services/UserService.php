<?php
namespace APP\plugins\generic\stametrics\services;

use APP\facades\Repo;
use PKP\security\Role;

class UserService
{
    public function getUsers($context)
    {
        $results = Repo::user()
            ->getCollector()
            ->filterByContextIds([$context->getId()])
            ->getQueryBuilder()
            ->get();

        return $results->map(fn($item) => [
            'username' => $item->username,
            'email' => $item->email,
        ])->toArray();
    }

    public function countUsers($context)
    {
        $collector = Repo::user()->getCollector();

        return Repo::user()
            ->getCollector()
            ->filterByContextIds([$context->getId()])
            ->filterByStatus($collector::STATUS_ACTIVE)
            ->getQueryBuilder()
            ->count();
    }

    public function countUsersByRole($context, $roleId)
    {
        $collector = Repo::user()->getCollector();

        return Repo::user()
            ->getCollector()
            ->filterByContextIds([$context->getId()])
            ->filterByRoleIds([$roleId])
            ->filterByStatus($collector::STATUS_ACTIVE)
            ->getQueryBuilder()
            ->count();
    }
}