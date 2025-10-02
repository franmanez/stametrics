<?php
namespace APP\plugins\generic\stametrics\services;

use APP\core\Application;
use APP\facades\Repo;
use APP\submission\Submission;
use Illuminate\Support\Facades\DB;
use PKP\db\DAORegistry;

class SubmissionService
{

    public function getEditorialStatsByYearREPO($context, int $year): array
    {
        $collector = Repo::submission()->getCollector()
            ->filterByContextIds([$context->getId()]);

        return [
            'received' => 2,
            'accepted' => 3,
        ];
    }

    public function getEditorialStatsByYear($context, int $year): array
    {

        $result = DB::table('submissions')
            ->selectRaw('status, COUNT(*) as total')
            ->where('context_id', $context->getId())
            ->whereYear('date_submitted', $year)
            ->groupBy('status')
            ->get();

        $stats = [
            'received' => 0,
            'queued' => 0,
            'published' => 0,
            'declined' => 0,
        ];

        foreach ($result as $item) {
            switch ($item->status) {
                case Submission::STATUS_QUEUED:
                    $stats['queued'] = $item->total;
                    break;
                case Submission::STATUS_PUBLISHED:
                    $stats['published'] = $item->total;
                    break;
                case Submission::STATUS_DECLINED:
                    $stats['declined'] = $item->total;
                    break;
            }
        }
        $stats['received'] = $stats['queued'] + $stats['published'] + $stats['declined'];

        return $stats;
    }
}