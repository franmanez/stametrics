<?php
namespace APP\plugins\generic\stametrics\services;

use APP\core\Application;
use APP\facades\Repo;
use APP\submission\Submission;
use Illuminate\Support\Facades\DB;
use PKP\db\DAORegistry;

class ArticleStatisticsService
{

    public function getArticleMetricsByMonth($context, int $yearMonth): array
    {
        $result = DB::table('metrics_counter_submission_monthly')
            ->selectRaw('
                `month`,
                SUM(metric_investigations) as total_investigations,
                SUM(metric_requests) as total_requests
            ')
            ->where('month', $yearMonth)
            ->groupBy('month')
            ->orderBy('month')
            ->first(); // obtenemos un solo registro, ya que es un mes específico

        // Si no hay datos para ese mes, devolvemos 0
        if (!$result) {
            return [
                'month' => $yearMonth,
                'total_investigations' => 0,
                'total_requests' => 0,
            ];
        }

        return [
            'month' => $result->month,
            'total_investigations' => (int) $result->total_investigations,
            'total_requests' => (int) $result->total_requests,
        ];
    }



    public function getArticleMetricsByYear($context, int $year): array
    {
        // Construimos el rango de meses para el año
        $startMonth = $year * 100 + 1;   // Ej: 202501
        $endMonth = $year * 100 + 12;    // Ej: 202512

        $results = DB::table('metrics_counter_submission_monthly')
            ->selectRaw('
            `month`,
            SUM(metric_investigations) as total_investigations,
            SUM(metric_requests) as total_requests
        ')
            ->whereBetween('month', [$startMonth, $endMonth])
            ->groupBy('month')
            ->orderBy('month', 'ASC')
            ->get();

        // Inicializamos array con todos los meses del año a 0
        $stats = [];
        for ($m = 1; $m <= 12; $m++) {
            $monthNumber = $year * 100 + $m;
            $stats[$monthNumber] = [
                'month' => $monthNumber,
                'total_investigations' => 0,
                'total_requests' => 0,
            ];
        }

        // Llenamos los datos que sí existen en la base
        foreach ($results as $row) {
            $stats[$row->month] = [
                'month' => $row->month,
                'total_investigations' => (int) $row->total_investigations,
                'total_requests' => (int) $row->total_requests,
            ];
        }

        return array_values($stats); // Devolvemos un array indexado del 0 al 11
    }
}