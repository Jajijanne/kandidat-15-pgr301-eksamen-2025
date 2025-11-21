package com.aialpha.sentiment.metrics;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.DistributionSummary;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class SentimentMetrics {

    private final MeterRegistry meterRegistry;

    // Gauge: antall selskaper i siste analyse
    private final AtomicInteger lastCompaniesDetected = new AtomicInteger(0);

    public SentimentMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;

        Gauge.builder("sentiment.companies.last", lastCompaniesDetected, AtomicInteger::get)
                .description("Number of companies detected in the last analysis")
                .register(meterRegistry);
    }

    // Counter: antall analyser tagget med metode
    public void recordRequest(String method) {
        Counter.builder("sentiment.analysis.count")
                .description("Total number of sentiment analyses")
                .tag("method", normalize(method))
                .register(meterRegistry)
                .increment();
    }

    // COunter: antall analyser per sentiment og selskap
    public void recordAnalysis(String sentiment, String company) {
        Counter.builder("sentiment.analysis.count")
                .description("Total number of sentiment analyses")
                .tag("sentiment", normalize(sentiment))
                .tag("company", normalize(company))
                .register(meterRegistry)
                .increment();
    }

    // Timer: måler Bedrock/Nova i ms, per selskap og modell
    public void recordDuration(long milliseconds, String company, String model) {
        Timer.builder("sentiment.bedrock.duration")
                .description("Latency for AWS Bedrock Nova model")
                .tag("company", normalize(company))
                .tag("model", normalize(model))
                .publishPercentileHistogram()
                .publishPercentiles(0.5, 0.9, 0.99)
                .register(meterRegistry)
                .record(Duration.ofMillis(milliseconds));
    }

    // DistributionSummary: fordeling av confidence (0..1) per sentiment og selskap
    public void recordConfidence(double confidence, String sentiment, String company) {
        double safeConfidence = Math.max(0.0, Math.min(1.0, confidence)); // clamp

        DistributionSummary.builder("sentiment.confidence")
                .description("Distribution of confidence scores (0..1)")
                .baseUnit("ratio")
                .maximumExpectedValue(1.0)
                .publishPercentiles(0.5, 0.9, 0.99)
                .publishPercentileHistogram()
                .tag("sentiment", normalize(sentiment))
                .tag("company", normalize(company))
                .register(meterRegistry)
                .record(safeConfidence);
    }

    // Gauge oppdatering: setter antall selskaper funnet i denne analysen
    public void recordCompaniesDetected(int count) {
        lastCompaniesDetected.set(Math.max(0, count));
    } 

    private String normalize(String value) {
        return (value == null || value.isBlank()) ? "unknown" : value;
    }
}
