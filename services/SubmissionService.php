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
            'accepted' => 0,
            'declined' => 0,
            'inReview' => 0,
        ];

        foreach ($result as $row) {
            switch ($row->status) {
                case Submission::STATUS_PUBLISHED:
                    $stats['accepted'] = $row->total;
                    break;
                case Submission::STATUS_DECLINED:
                    $stats['declined'] = $row->total;
                    break;
                case Submission::STATUS_QUEUED:
                    $stats['inReview'] = $row->total;
                    break;
            }
            $stats['received'] += $row->total;
        }
        return [];
    }
}